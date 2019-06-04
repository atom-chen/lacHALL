# -*- coding: UTF-8 -*-
#!/usr/bin/python
#coding:utf-8
import os
import sys
import hashlib
import time
import datetime
import shutil
from OpenSSL.crypto import *

default_encoding = 'utf-8'
if sys.getdefaultencoding() != default_encoding:
    reload(sys)
    sys.setdefaultencoding(default_encoding)

sys.path.append(os.path.dirname(os.path.dirname(__file__)))
from python_libs.Common import Common
from python_libs.FileUtils import FileUtils
from python_libs.JsonObj import JsonObj
from python_libs.Sed import Sed
from python_libs.Plist import Plist
from python_libs.String import String

from obscure.Obscure import Obscurer

# 引擎代码需要跳过顶象混淆的百分比
ENGINE_SKIP_PERCENT = 100

m_configPath = None
m_projectDir = None
m_infoPlistPath = None
m_projectName = None
m_schemeName = None
m_versionName = None
m_buildName = None
m_newDisplayName = None
m_newBundleId = None
m_newNotifyBundleId = None
m_newProjName = None
m_newSchemeName = None
m_archiveType = None
m_profilePath = None
m_notifProfilePath = None
m_jsonObj = JsonObj()

Archive_Type_Key_AdHoc = "AdHoc"
Archive_Type_Key_AppStore = "AppStore"

# 临时生成的plist路径
def getTmpPlistPath():
    return os.path.join(getIpaDir(), "tmp.plist")

# 临时生成的notify plist路径
def getTmpNotifyPlistPath():
    return os.path.join(getIpaDir(), "notifyTmp.plist")

# ipa文件夹路径
def getIpaDir():
    if m_outputPath is not None:
        return m_outputPath

    return os.path.join(FileUtils.getDesktopPath(), "Package")

# 打包文件
def getArchivePath():
    ipaDir = getIpaDir()
    return os.path.join(ipaDir, "archive.xcarchive")

# 出包类型配置文件路径
def getExportOptionsPlist():
    optionsDic = {
        Archive_Type_Key_AdHoc : "certificate/AdHocExportOptionsPlist.plist",
        Archive_Type_Key_AppStore : "certificate/AppStoreExportOptionsPlist.plist",
    }

    plistName = optionsDic[m_archiveType]
    curDir = FileUtils.getScriptDirectory()
    return os.path.join(curDir, plistName)

def getAbspath(key):
    Common.assertExit(m_jsonObj[key], "config配置文件缺少参数key=" + key)

    if os.path.isabs(m_jsonObj[key]):
        return m_jsonObj[key]

    configDir = FileUtils.getFileDirectory(m_configPath)
    return FileUtils.getAbsoluteFromPath(configDir, m_jsonObj[key])

# 读取配置表
def loadConfig():
    global m_projectDir
    global m_infoPlistPath
    global m_notify_info_plist_path
    global m_projectName
    global m_schemeName
    global m_versionName
    global m_buildName
    global m_newDisplayName
    global m_newBundleId
    global m_newNotifyBundleId
    global m_archiveType
    global m_profilePath
    global m_notifProfilePath
    global m_configPath
    global m_jsonObj
    global m_outputPath
    global m_games
    global m_newProjName
    global m_newSchemeName
    global m_isNoDingXiang # 是否不使用顶象加固

    Common.assertExit(len(sys.argv[1:])!=0, "请传入配置文件绝对路径")
    Common.assertExit(os.path.isfile(sys.argv[1]), "传入参数文件不存在")
    m_configPath = sys.argv[1]

    # print "使用测试配置"
    # m_configPath = "/Users/weile/Desktop/SVN/tools/PackIOS/proj_template/config.json"

    m_jsonObj.loadFromFilePath(m_configPath)

    m_isNoDingXiang = m_jsonObj["isNoDingXiang"]

    m_projectDir = getAbspath("project_dir")
    m_infoPlistPath = getAbspath("info_plist_path")

    m_notify_info_plist_path = FileUtils.getAbsoluteFromPath(m_projectDir, "notificationService/Info.plist")

    m_archiveType = m_jsonObj["archive_type"]
    Common.assertExit(m_archiveType=='AdHoc' or m_archiveType=='AppStore', "archive_type参数只能是AdHoc和AppStore")
    paths = {
        Archive_Type_Key_AdHoc : getAbspath("profile_path_AdHoc"),
        Archive_Type_Key_AppStore : getAbspath("profile_path_AppStore"),
    }
    m_profilePath = paths[m_archiveType]
    Common.assertExit(os.path.isfile(m_profilePath), "配置证书文件不存在，请检查配置")

    notifyPaths = {
        Archive_Type_Key_AdHoc : getAbspath("notifProfile_path_AdHoc"),
        Archive_Type_Key_AppStore : getAbspath("notifProfile_path_AppStore"),
    }
    m_notifProfilePath = notifyPaths[m_archiveType]
    Common.assertExit(os.path.isfile(m_notifProfilePath), "NotificationService证书文件不存在，请检查配置")

    m_projectName = m_jsonObj["project_name"]
    m_schemeName = m_jsonObj["scheme_name"]
    m_versionName = m_jsonObj["version_name"]
    m_buildName = m_jsonObj["build_name"]
    m_newDisplayName = m_jsonObj["game_name"]
    m_newBundleId = m_jsonObj["pkg_name"]
    m_newNotifyBundleId = m_newBundleId + ".notifyService"
    m_games = m_jsonObj["games"]
    m_newProjName = m_jsonObj["proj_name_new"]

    Common.assertExit(m_jsonObj["app_scheme"], "必须配置app_scheme参数")
    Common.assertExit(m_jsonObj["weixin_id"], "必须配置weixin_id参数")
    Common.assertExit(m_newProjName, "必须配置 proj_name_new 参数")
    Common.assertExit(m_projectName != m_newProjName, "proj_name_new 与 project_name 的值不能相同")

    m_newSchemeName = "%s-mobile" % m_newProjName

    if m_jsonObj["track_id"] is None:
        # track_id 必须配置。如果配置为空字符串，效果与不集成热云 SDK 一致
        Common.assertExit(False, "必须配置track_id参数，请联系商务获取热云的 app key")
    if (not m_jsonObj["getui_appId"] or not m_jsonObj["getui_appKey"] or not m_jsonObj["getui_appSecret"]) and m_jsonObj["turnOffPush"] != "1":
        # getui 必须配置。如不需要getui需要在config.json文件里添加"turnOffPush": "1"
        Common.assertExit(False, "必须配置getui参数，个推后台获取")

    Common.assertExit(m_jsonObj["region"], '必须配置region参数，值为地区码字符串。如："region":"23"')
    Common.assertExit(m_jsonObj["build_name"], "必须配置build_name参数")

    if m_jsonObj["output"]:
        m_outputPath = getAbspath("output")
    else:
        m_outputPath = None

# 安装p12证书
def installP12():
    p12Path = getAbspath("p12_path")
    Common.assertExit(os.path.isfile(p12Path), "p12证书文件不存在，请检查配置")

    p12Password = m_jsonObj["p12_password"]
    Common.assertExit(p12Password, "未配置参数p12_password")
    p12Cmd = "security import %s -k /Users/%s/Library/Keychains/login.keychain -P %s -T /usr/bin/codesign"%(p12Path, Common.getUserName(), p12Password)
    Common.runCmd(p12Cmd)

# 找到临时文件plist某字段的值
def findPlistInfoForKey(key):
    tmpPlistPath = getTmpPlistPath()
    cmd = "/usr/libexec/PlistBuddy -c 'Print %s' %s" % (key, tmpPlistPath)
    result = Common.getCmdResult(cmd)
    Common.assertExit(result.find(key)==-1, "查找字段不存在:key="+key+"(苹果对证书信息做了修改，请查看桌面/Package/tmp.plist数据格式)")
    return result

def findNotifyPlistInfoForKey(key):
    tmpPlistPath = getTmpNotifyPlistPath()
    cmd = "/usr/libexec/PlistBuddy -c 'Print %s' %s" % (key, tmpPlistPath)
    result = Common.getCmdResult(cmd)
    Common.assertExit(result.find(key)==-1, "查找字段不存在:key="+key+"(苹果对证书信息做了修改，请查看桌面/Package/tmp.plist数据格式)")
    return result

# 安装mobileprovision证书
def installProfile():
    # 把mobileprovision转成plist获取信息
    tmpPlistPath = getTmpPlistPath()
    cmd = "security cms -D -i %s > %s" % (m_profilePath, tmpPlistPath)
    Common.runCmd(cmd)

    # 将profile文件拷贝到系统目录
    uuid = findPlistInfoForKey("UUID")
    targetFile = "/Users/%s/Library/MobileDevice/Provisioning Profiles/%s.mobileprovision" % (Common.getUserName(), uuid)
    FileUtils.copyFile(m_profilePath, targetFile)

def installNotifyProfile():
    tmpPlistPath = getTmpNotifyPlistPath()
    cmd = "security cms -D -i %s > %s" % (m_notifProfilePath, tmpPlistPath)
    Common.runCmd(cmd)

    # 将profile文件拷贝到系统目录
    uuid = findNotifyPlistInfoForKey("UUID")
    targetFile = "/Users/%s/Library/MobileDevice/Provisioning Profiles/%s.mobileprovision" % (Common.getUserName(), uuid)
    FileUtils.copyFile(m_notifProfilePath, targetFile)

# 拷贝配置文件
def copyConfigFile(file_recorder):
    targetConfigFile = FileUtils.getAbsolutePath("./shell_script/config.json")
    file_recorder.record_file(targetConfigFile)
    FileUtils.copyFile(m_configPath, targetConfigFile)

    configDir = FileUtils.getFileDirectory(m_configPath)
    sourceCfgDir = os.path.join(configDir, "cfg")
    Common.assertExit(os.path.isdir(sourceCfgDir), "cfg配置文件夹不存在"+sourceCfgDir)

    # 检查 cfg_package 中是否定义了 APPLE_ID
    cfg_pkg_file = os.path.join(sourceCfgDir, "cfg_package.lua")
    Common.assertExit(os.path.isfile(cfg_pkg_file), "cfg配置文件夹中不存在 cfg_package 文件")
    f = open(cfg_pkg_file)
    content = f.read()
    f.close()
    if content.find("APPLE_ID") == -1:
        Common.assertExit(False, "cfg_package 中未配置 APPLE_ID ")

    targetCfgDir = FileUtils.getAbsolutePath("./shell_script/cfg")
    file_recorder.record_folder(targetCfgDir)
    FileUtils.replaceCopyDirctory(sourceCfgDir, targetCfgDir)

def copyResFiles(file_recorder):
    resDir = FileUtils.getFileDirectory(m_configPath)
    sourceResDir = os.path.abspath(os.path.join(resDir, "res"))
    if not os.path.isdir(sourceResDir):
        return

    targetResDir = FileUtils.getAbsolutePath("./shell_script/res")
    file_recorder.record_folder(targetResDir)
    FileUtils.replaceCopyDirctory(sourceResDir, targetResDir)

# 拷贝icons
def copyIcons(file_recorder):
    sourceDir = getAbspath("icons_source")
    targetDir = os.path.join(m_projectDir, 'ios/Images.xcassets/AppIcon.appiconset')
    file_recorder.record_folder(targetDir)
    FileUtils.copyDirctory(sourceDir, targetDir)

# 拷贝launch启动图片
def copyLaunchImages(file_recorder):
    sourceDir = getAbspath("launch_iamge_source")
    targetDir = getAbspath("launch_iamge_target")
    file_recorder.record_folder(targetDir)
    FileUtils.copyDirctory(sourceDir, targetDir)

# 创建一个新名字的 xcode 工程
def createNewProj(file_recorder, tmp_files):
    srcDir = os.path.join(m_projectDir, "%s.xcodeproj" % m_projectName)
    dstDir = os.path.join(m_projectDir, "%s.xcodeproj" % m_newProjName)
    FileUtils.copyDirctory(srcDir, dstDir)

    tmp_files.append(dstDir)

    # delete the origin project dir
    # file_recorder.record_folder(srcDir)
    # FileUtils.removeDirectory(srcDir)

    # 拷贝配置文件
    srcFile = os.path.join(m_projectDir, "WeiLeProjV3-mobile.entitlements")
    Common.assertExit(os.path.isfile(srcFile), "文件 %s 不存在" % srcFile)
    dstFile = os.path.join(m_projectDir, "%s-mobile.entitlements" % m_newProjName)
    FileUtils.copyFile(srcFile, dstFile)
    tmp_files.append(dstFile)

    # 修改工程名字
    projFilePath = getProjectConfigPath()
    Sed.replaceContent(m_projectName, m_newProjName, projFilePath)

    # 移除临时文件
    for item in os.listdir(dstDir):
        full_path = os.path.join(dstDir, item)
        if full_path == projFilePath:
            continue

        if os.path.isdir(full_path):
            FileUtils.removeDirectory(full_path)
        elif os.path.isfile(full_path):
            FileUtils.removeFile(full_path)

def modifyLibsName(file_recorder, tmp_files):
    libs = [
        '../IM_SDK/ios/libYvImSdk.102j.a',
        '../IM_SDK/ios/libYvToolsManager.a',
        '../library.chat.ios/libchat.a',
        '../../libHall/prebuilt/ios/libhall IOS.a',
        'ios/sdks/h5/libJXPApi.a',
        'ios/sdks/tracking/TrackingIO.a',
        'ios/sdks/wechat/libWeChatSDK.a'
    ]
    projFilePath = getProjectConfigPath()
    for lib in libs:
        full_path = os.path.join(m_projectDir, lib)
        dir_name, file_name = os.path.split(full_path)
        base_name, ext = os.path.splitext(file_name)

        file_recorder.record_file(full_path)
        ts_str = datetime.datetime.fromtimestamp(time.time()).strftime('%Y%m%d%H%M%S')
        dst_file = '%s/%s-%s%s' % (dir_name, base_name, ts_str, ext)
        FileUtils.copyFile(full_path, dst_file)
        tmp_files.append(dst_file)

        Sed.replaceContent(file_name, os.path.basename(dst_file), projFilePath)

# 安装证书
def installCertificate():
    # 安装p12证书
    installP12()

    # 安装profile证书
    installProfile()
    installNotifyProfile()

# 清理目标工程
def cleanTarget():
    Common.runCmd('cd %s;xcodebuild clean -project "%s.xcodeproj" -alltargets' % (m_projectDir, m_newProjName))

# 修改版本号
def modifyVersion():
    Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString %s" %s' % (m_versionName, m_infoPlistPath))
    Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleVersion %s" %s' % (m_buildName, m_infoPlistPath))
    # 修改推送版本号,与游戏工程一致
    Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString %s" %s' % (m_versionName, m_notify_info_plist_path))
    Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleVersion %s" %s' % (m_buildName, m_notify_info_plist_path))

# 修改URLTypes
def modifyURLTypes():
    # 修改微信id
    urlName = Plist.getForKey(m_infoPlistPath, "CFBundleURLTypes:0:CFBundleURLName")
    Common.assertBoolType(urlName=="wechatshceme", "info.plist的URL TYPES的第一个值必须是wechatshceme")
    weixinUrlScheme = m_jsonObj["weixin_id"]
    idsArray = weixinUrlScheme.split(",")
    Plist.resetArrayForKey(m_infoPlistPath, "CFBundleURLTypes:0:CFBundleURLSchemes", idsArray)

    # 修改第三个值
    urlName = Plist.getForKey(m_infoPlistPath, "CFBundleURLTypes:2:CFBundleURLName")
    Common.assertBoolType(urlName=="com.weile.www", "info.plist的URL TYPES的第三个值必须是com.weile.www")
    appScheme = m_jsonObj["app_scheme"]
    Plist.setForKey(m_infoPlistPath, "CFBundleURLTypes:2:CFBundleURLSchemes:0", appScheme)

# 修改App显示名称
def modifyDisplayName():
    cmd = '/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName %s" %s' % (m_newDisplayName, m_infoPlistPath)
    Common.runCmd(cmd)

# 修改Bundle Id
def modifyBundleId():
    Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier %s" %s' % (m_newBundleId, m_infoPlistPath))
    # 修改推送BundleId
    Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier %s" %s' % (m_newNotifyBundleId, m_notify_info_plist_path))

# 修改热云的 Track app key
def modifyTrackID(file_recorder):
    curDir = FileUtils.getScriptDirectory()
    filepath = os.path.join(curDir, "../../frameworks/runtime-src/proj.ios_mac/ios/AppController.mm")
    file_recorder.record_file(filepath)

    target_str = r'trackingAppKey = @\"%s\"' % m_jsonObj["track_id"]
    Sed.replaceContent(r'trackingAppKey = @\".*\"', target_str, filepath)

def modifyGetuiId(file_recorder):
    curDir = FileUtils.getScriptDirectory()
    filepath = os.path.join(curDir, "../../frameworks/runtime-src/proj.ios_mac/ios/AppController.mm")
    # file_recorder.record_file(filepath)

    target_str = r'getuiAppId = @\"%s\"' % m_jsonObj["getui_appId"]
    Sed.replaceContent(r'getuiAppId = @\".*\"', target_str, filepath)
    target_str = r'getuiAppKey = @\"%s\"' % m_jsonObj["getui_appKey"]
    Sed.replaceContent(r'getuiAppKey = @\".*\"', target_str, filepath)
    target_str = r'getuiAppSecret = @\"%s\"' % m_jsonObj["getui_appSecret"]
    Sed.replaceContent(r'getuiAppSecret = @\".*\"', target_str, filepath)

# 修改宏定义
def modifyCocosMacros(file_recorder):
    curDir = FileUtils.getScriptDirectory()
    filepath = os.path.join(curDir, "../../frameworks/cocos2d-x/cocos/platform/CCPlatformMacros.h")
    file_recorder.record_file(filepath)

    cur_time_str = datetime.datetime.fromtimestamp(time.time()).strftime('%Y%m%d_%H%M%S')
    md5Hash = hashlib.md5(m_jsonObj["pkg_name"] + cur_time_str)
    md5Hashed = md5Hash.hexdigest()

    Sed.replaceContent("#define UINQUEID MYUINQUEID", "#define UINQUEID " + md5Hashed, filepath)

def modifyEnginCompilerFlags(file_recorder):
    if m_isNoDingXiang == "1":
        return

    # 修改 xcode 工程
    projPath = getEngineConfigPath()
    Common.assertExit(os.path.isfile(projPath), '文件 %s 不存在' % projPath)

    file_recorder.record_file(projPath)
    sys.path.append(os.path.join(os.path.dirname(__file__), 'obscure'))
    from modify_pbxproj import XcodeProject
    pbx_obj = XcodeProject.Load(projPath)

    build_phase = pbx_obj.get_build_phases('PBXSourcesBuildPhase', 'libcocos2d iOS')
    build_files = pbx_obj.get_build_files_for_phases(build_phase)
    need_skip_files = []
    if ENGINE_SKIP_PERCENT >= 100:
        need_skip_files = build_files
    else:
        skip_count = int(len(build_files) * ENGINE_SKIP_PERCENT / 100)
        import random
        random.seed()
        random.shuffle(build_files)
        for i in range(skip_count):
            need_skip_files.append(build_files[i])

    for f in need_skip_files:
        setting = { 'COMPILER_FLAGS' : '-skip-steec' }
        pbx_obj.set_build_file_settings(f, setting)

    if pbx_obj.modified:
        pbx_obj.save()

# 增加 H5 支付的支持
def addH5PaySupport(file_recorder):
    curDir = FileUtils.getScriptDirectory()

    # 修改代码
    codePath = os.path.join(curDir, "../../frameworks/runtime-src/proj.ios_mac/ios/sdks/SdkManager.mm")
    file_recorder.record_file(codePath)

    f = open(codePath)
    content = f.read()
    f.close()
    content = content.replace('//#import "JXPApi.h"', '#import "JXPApi.h"')
    content = content.replace('// [JXPApi PApiRequestURL', '[JXPApi PApiRequestURL')
    f = open(codePath, 'w')
    f.write(content)
    f.close()

    # 修改 xcode 工程
    projPath = getProjectConfigPath()
    file_recorder.record_file(projPath)

    sys.path.append(os.path.join(os.path.dirname(__file__), 'obscure'))
    from modify_pbxproj import XcodeProject
    pbx_obj = XcodeProject.Load(projPath)
    h5Folder = os.path.join(curDir, "../../frameworks/runtime-src/proj.ios_mac/ios/sdks/h5")

    iosGroup = pbx_obj.get_or_create_group('ios')
    sdkGroup = pbx_obj.get_or_create_group('sdks', parent=iosGroup)
    h5Group = pbx_obj.get_or_create_group('h5', parent=sdkGroup)

    for f in os.listdir(h5Folder):
        fullPath = os.path.join(h5Folder, f)
        name, ext = os.path.splitext(fullPath)
        if ext == '.h' or ext == '.a':
            pbx_obj.add_file_if_doesnt_exist(fullPath, parent=h5Group, target='%s-mobile' % m_newProjName)

    if pbx_obj.modified:
        pbx_obj.save()

# 创建ipa文件夹
def createIpaDir():
    ipaDir = getIpaDir()
    FileUtils.createDirectory(ipaDir)

# 编译工程
def buildTarget():
    archivePath = getArchivePath()
    profileUUID = Common.getCmdResult("/usr/libexec/PlistBuddy -c 'Print UUID' " + getTmpPlistPath())

    notifyProfileUUID = Common.getCmdResult("/usr/libexec/PlistBuddy -c 'Print UUID' " + getTmpNotifyPlistPath())

    print 'notifyProfile uuid==%s  m_newNotifyBundleId==%s' % (notifyProfileUUID, m_newNotifyBundleId)

    p12Path = getAbspath("p12_path")
    p12Password = m_jsonObj["p12_password"]
    f = open(p12Path, 'rb')
    p12 = load_pkcs12(f.read(), p12Password)
    sign_key = p12.get_friendlyname()
    team_id = p12.get_certificate().get_subject().OU
    f.close()

    buildParams = ' '.join([
        '-project', '%s.xcodeproj' % m_newProjName,
        '-scheme', m_newSchemeName,
        '-configuration', 'Release',
        '-archivePath', archivePath,
        'archive', 'build',
        'CODE_SIGN_IDENTITY="%s"' % sign_key,
        'APP_PROVISIONING_PROFILE="%s"' % profileUUID,
        'APP_BUNDLE_IDENTIFIER="%s"' % m_newBundleId,
        'EXTENSION_PROFILE="%s"' % notifyProfileUUID,
        'EXTENSION_BUNDLE_IDENTIFIER="%s"' % m_newNotifyBundleId,
        'CODE_SIGN_STYLE="Manual"',
        'DEVELOPMENT_TEAM="%s"' % team_id
    ])
    # 添加顶象加固
    if m_isNoDingXiang != "1":
        buildParams += " DX_FLAGS=-steec-extra-opts=-xse=100,-fla=50,-spli=50"
        buildParams += " -toolchain dx-vm.lite"
    else:
        buildParams += ' DX_FLAGS=""'

    cmd = 'cd %s;xcodebuild %s' % (m_projectDir, buildParams)
    Common.runCmd(cmd)

# 保留已有ipa包
def exportPath():
    number = 1
    while 1:
        ipaDir = getIpaDir()
        ipaName = "%s_%s_%s_第%d版" % (m_newDisplayName, m_versionName, m_archiveType, number)
        ipaDir = os.path.join(ipaDir, ipaName)
        if not os.path.isdir(ipaDir):
            return ipaDir
        number = number + 1


# 打成ipa包
def createIPA():
    ipaPath = exportPath()
    archivePath = getArchivePath()

    plistPath = getExportOptionsPlist()
    cmd = "cd %s;xcodebuild -exportArchive -archivePath %s -exportPath %s -exportOptionsPlist %s"%(m_projectDir, archivePath, ipaPath, plistPath)
    # print "====== " + ipaPath
    Common.runCmd(cmd)

# 更新ExportOptionsPlist配置信息
def refreshExportOptionsPlist(file_recorder):
    plistPath = getExportOptionsPlist()
    key = "provisioningProfiles:" + m_newBundleId
    uuid = findPlistInfoForKey("UUID")
    file_recorder.record_file(plistPath)
    Plist.setForKey(plistPath, key, uuid)

    #刷新notificationService配置
    key = "provisioningProfiles:" + m_newNotifyBundleId
    uuid = findNotifyPlistInfoForKey("UUID")
    Plist.setForKey(plistPath, key, uuid)

# 项目工程配置文件路径
def getProjectConfigPath():
    return "%s/%s.xcodeproj/project.pbxproj" % (m_projectDir, m_newProjName)

def getEngineConfigPath():
    return "%s/../../cocos2d-x/build/cocos2d_libs.xcodeproj/project.pbxproj" % m_projectDir

# 获取字符串对应的 hash 码
def getHashCode(srcStr):
    basename, ext = os.path.splitext(srcStr)
    paths = basename.split('/')
    new_paths = []
    for p in paths:
        useStr = '%s%s' % (m_newBundleId, p)
        md5Hash = hashlib.md5(useStr)
        md5Hashed = md5Hash.hexdigest()
        new_paths.append(md5Hashed)

    return '%s%s' % ('/'.join(new_paths), ext)

def convertFilePath(oriPath):
    retPath = oriPath
    fileName = os.path.basename(oriPath)
    basename, ext = os.path.splitext(fileName)
    # 考虑加密的情况
    if fileName == 'manifest':
        retPath = '%s.wld' % retPath
    elif ext == '.lua':
        retPath = os.path.join(os.path.dirname(oriPath), '%s.wld' % basename)

    return  retPath

# 生成资源文件混淆路径信息头文件
RES_INFO_HEADER_PATH = 'ResFilesInfo.h'
INSERT_BEGIN_KEYWORDS = 'insert begin'
INSERT_LINE_TEMPLATE = '        s_resFilesInfo["%s"] = "%s";\n'
def genResFilesInfo(file_recorder):
    headerPath = os.path.join(m_projectDir, RES_INFO_HEADER_PATH)
    Common.assertExit(os.path.isfile(headerPath), '%s 文件不存在' % headerPath)

    # 扫描需要记录的文件信息
    curDir = os.path.dirname(__file__)
    hallRoot = os.path.dirname(os.path.dirname(curDir))
    srcPath = os.path.join(hallRoot, 'src')
    resPath = os.path.join(hallRoot, 'res')
    gamesDir = os.path.join(os.path.dirname(hallRoot), 'games')
    cfgDir = os.path.join(curDir, 'shell_script/cfg')
    relative_paths = {}
    scanDirs = {
        srcPath : 'src',
        resPath : 'res',
        cfgDir : 'src'
    }

    for g in m_games:
        key = os.path.join(gamesDir, g)
        scanDirs[key] = ('games/%s' % g)

    # 先把 NativeInfo.lua 加进去
    native_info_path = "src/NativeInfo.lua"
    rel_path = convertFilePath(native_info_path)
    relative_paths[rel_path] = getHashCode(rel_path)
    for dir in scanDirs:
        prefix = scanDirs[dir]
        Common.assertExit(os.path.isdir(dir), "%s 文件夹不存在" % dir)
        for parent, dirs, files in os.walk(dir):
            for f in files:
                if f == '.git' or f == '.DS_Store':
                    continue

                full_path = os.path.join(parent, f)
                rel_path = os.path.relpath(full_path, dir)
                rel_path.lstrip('./')
                if len(prefix) > 0:
                    rel_path = '%s/%s' % (prefix, rel_path)

                rel_path = convertFilePath(rel_path)
                if not relative_paths.has_key(rel_path):
                    relative_paths[rel_path] = getHashCode(rel_path)

    file_recorder.record_file(headerPath)

    # 写文件
    f = open(headerPath)
    lines = f.readlines()
    f.close()

    dumpLines = []
    newLines = []
    for line in lines:
        newLines.append(line)
        if line.find(INSERT_BEGIN_KEYWORDS) > 0:
            # 插入数据
            for key in relative_paths.keys():
                dumpLines.append('"%s" : "%s"' % (key, relative_paths[key]))
                newLines.append(INSERT_LINE_TEMPLATE % (key, relative_paths[key]))

    f = open(headerPath, 'w')
    f.writelines(newLines)
    f.close()

    cur_time_str = datetime.datetime.fromtimestamp(time.time()).strftime('%Y%m%d_%H%M%S')
    dumpFileName = 'DumpPathMap_%s.json' % cur_time_str
    dumpContent = '{\n%s\n}\n' % ',\n'.join(dumpLines)
    f = open(os.path.join(getIpaDir(), dumpFileName), 'w')
    f.write(dumpContent)
    f.close()

def copyDingXiangFiles():
    if m_isNoDingXiang != "1":
        curDir = os.path.dirname(__file__)
        chainPath = os.path.join(curDir, "dingxiang/DX-VM.lite.xctoolchain")
        keyPath = os.path.join(curDir, "dingxiang/license.key")
        targetDir = os.path.expanduser(os.path.join('~/Library/Developer/Toolchains', 'DX-VM.lite.xctoolchain'))
        if os.path.isdir(targetDir):
            shutil.rmtree(targetDir)
        targetFile = os.path.expanduser(os.path.join('~/Library/Developer/Toolchains', 'license.key'))
        if os.path.isfile(targetFile):
            os.remove(targetFile)
        Common.runCmd("mkdir -p ~/Library/Developer/Toolchains")
        Common.runCmd("cp -R %s %s ~/Library/Developer/Toolchains" % (chainPath, keyPath))

if __name__ == "__main__":
    # record the start time
    begin_time = time.time()
    tmp_files = []

    # 读取配置表
    loadConfig()

    sys.path.append(os.path.normpath(os.path.join(os.path.dirname(__file__), '../utils')))
    import utils
    file_recorder = utils.FileRollback()
    file_recorder.record_file(m_infoPlistPath)
    file_recorder.record_file(m_notify_info_plist_path)

    try:
        # 拷贝顶象加固相关文件
        copyDingXiangFiles()

        # 拷贝配置文件
        copyConfigFile(file_recorder)

        # 拷贝 res 文件
        copyResFiles(file_recorder)

        # 拷贝icons文件
        copyIcons(file_recorder)

        # 拷贝launch启动图片
        copyLaunchImages(file_recorder)

        # 创建一个新名字的 xcode 工程
        createNewProj(file_recorder, tmp_files)

        # 修改库文件名字
        modifyLibsName(file_recorder, tmp_files)

        # 创建IPA文件夹
        createIpaDir()

        # 安装证书
        installCertificate()

        # 修改版本号
        modifyVersion()

        # 修改URL TYPES
        modifyURLTypes()

        # 修改App显示名称
        modifyDisplayName()

        # 修改Bundle Id
        modifyBundleId()

        # 修改热云的 Track app key
        modifyTrackID(file_recorder)

        # 修改个推的 appId appKey appSer
        modifyGetuiId(file_recorder)

        # 修改Cocos宏定义
        modifyCocosMacros(file_recorder)

        # 修改引擎的 compiler flags
        # modifyEnginCompilerFlags(file_recorder)

        # 默认已支持 H5 支付，这里不需要再处理
        # addH5PaySupport(file_recorder)

        # 生成资源文件混淆路径信息头文件
        genResFilesInfo(file_recorder)

        # 添加混淆代码
        if m_isNoDingXiang == "1":
            obscurer = Obscurer(getProjectConfigPath(), m_newSchemeName, file_recorder)
            obscurer.add_obscure_code()

        # 清理目标工程
        cleanTarget()

        # 更新exportOptionsPlist配置
        refreshExportOptionsPlist(file_recorder)

        # 编译工程
        buildTarget()

        # 打成ipa包
        createIPA()
    except:
        pass
    finally:
        file_recorder.do_rollback()

        for item in tmp_files:
            if os.path.isfile(item):
                FileUtils.removeFile(item)
            elif os.path.isdir(item):
                FileUtils.removeDirectory(item)
            else:
                print("%s 不是文件/文件夹，删除失败" % item)

        # output the spend time
        end_time = time.time()
        print('\n总共用时： %.2f 秒\n' % (end_time - begin_time))

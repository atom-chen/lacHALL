# -*- coding: UTF-8 -*-
#!/usr/bin/python
#coding:utf-8

import os
import sys
import time
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

from obscure.Obscure import Obscurer

m_configPath = None
m_projectDir = None
m_infoPlistPath = None
m_projectName = None
m_schemeName = None
m_versionName = None
m_buildName = None
m_newDisplayName = None
m_newBundleId = None
m_newProjName = None
m_newSchemeName = None
m_archiveType = None
m_profilePath = None
m_jsonObj = JsonObj()

Archive_Type_Key_AdHoc = "AdHoc"
Archive_Type_Key_AppStore = "AppStore"

# 临时生成的plist路径
def getTmpPlistPath():
    return os.path.join(getIpaDir(), "tmp.plist")

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
    global m_projectName
    global m_schemeName
    global m_versionName
    global m_buildName
    global m_newDisplayName
    global m_newBundleId
    global m_archiveType
    global m_profilePath
    global m_configPath
    global m_jsonObj
    global m_outputPath
    global m_games
    global m_newProjName
    global m_newSchemeName

    Common.assertExit(len(sys.argv[1:])!=0, "请传入配置文件绝对路径")
    Common.assertExit(os.path.isfile(sys.argv[1]), "传入参数文件不存在")
    m_configPath = sys.argv[1]

    # print "使用测试配置"
    # m_configPath = "/Users/weile/Desktop/SVN/tools/PackIOS/proj_template/config.json"

    # "game_name": "家乡棋牌·微乐",
    # "pkg_name": "com.wljiaxiang.mj",
    # "version_name": "1.1.1",
    # "build_name": "1.1.1.7",

    m_jsonObj.loadFromFilePath(m_configPath)

    m_projectDir = os.path.join(os.path.dirname(__file__), "proj.ios.demo/com.weile.test")
    m_infoPlistPath = os.path.join(m_projectDir, "Info.plist")

    m_archiveType = m_jsonObj["archive_type"]
    Common.assertExit(m_archiveType=='AdHoc' or m_archiveType=='AppStore', "archive_type参数只能是AdHoc和AppStore")
    paths = {
        Archive_Type_Key_AdHoc : getAbspath("profile_path_AdHoc"),
        Archive_Type_Key_AppStore : getAbspath("profile_path_AppStore"),
    }
    m_profilePath = paths[m_archiveType]
    Common.assertExit(os.path.isfile(m_profilePath), "配置证书文件不存在，请检查配置")

    m_projectName = "demo"
    m_schemeName = "com.weile.test"
    m_versionName = m_jsonObj["version_name"]
    m_buildName = m_jsonObj["build_name"]
    m_newDisplayName = m_jsonObj["game_name"]
    m_newBundleId = m_jsonObj["pkg_name"]
    m_newProjName = m_jsonObj["proj_name_new"]

    Common.assertExit(m_newProjName, "必须配置 proj_name_new 参数")
    Common.assertExit(m_projectName != m_newProjName, "proj_name_new 与 project_name 的值不能相同")

    m_newSchemeName = m_newProjName

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

# 创建一个新名字的 xcode 工程
def createNewProj(file_recorder, tmp_files):
    srcDir = os.path.join(m_projectDir, "../%s.xcodeproj" % m_projectName)
    dstDir = os.path.join(m_projectDir, "../%s.xcodeproj" % m_newProjName)
    FileUtils.copyDirctory(srcDir, dstDir)

    tmp_files.append(dstDir)

    # # 拷贝配置文件
    # srcFile = os.path.join(m_projectDir, "WeiLeProjV3-mobile.entitlements")
    # Common.assertExit(os.path.isfile(srcFile), "文件 %s 不存在" % srcFile)
    # dstFile = os.path.join(m_projectDir, "%s-mobile.entitlements" % m_newProjName)
    # FileUtils.copyFile(srcFile, dstFile)
    # tmp_files.append(dstFile)

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

# 安装证书
def installCertificate():
    # 安装p12证书
    installP12()

    # 安装profile证书
    installProfile()

# 清理目标工程
def cleanTarget():
    Common.runCmd('cd %s/..;xcodebuild clean -project "%s.xcodeproj" -alltargets' % (m_projectDir, m_newProjName))

# 修改版本号
def modifyVersion():
    Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString %s" %s' % (m_versionName, m_infoPlistPath))
    Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleVersion %s" %s' % (m_buildName, m_infoPlistPath))

# 修改App显示名称
def modifyDisplayName():
    cmd = '/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName %s" %s' % (m_newDisplayName, m_infoPlistPath)
    Common.runCmd(cmd)

# 修改Bundle Id
def modifyBundleId():
    Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier %s" %s' % (m_newBundleId, m_infoPlistPath))

# 创建ipa文件夹
def createIpaDir():
    ipaDir = getIpaDir()
    FileUtils.createDirectory(ipaDir)

# 编译工程
def buildTarget():
    archivePath = getArchivePath()
    profileUUID = Common.getCmdResult("/usr/libexec/PlistBuddy -c 'Print UUID' " + getTmpPlistPath())

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
        'PROVISIONING_PROFILE="%s"' % profileUUID,
        'PRODUCT_BUNDLE_IDENTIFIER="%s"' % m_newBundleId,
        'CODE_SIGN_STYLE="Manual"',
        'DEVELOPMENT_TEAM="%s"' % team_id
    ])

    cmd = 'cd %s/..;xcodebuild %s' % (m_projectDir, buildParams)
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

# 项目工程配置文件路径
def getProjectConfigPath():
    return "%s/../%s.xcodeproj/project.pbxproj" % (m_projectDir, m_newProjName)

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

    try:
        # 创建一个新名字的 xcode 工程
        createNewProj(file_recorder, tmp_files)

        # 创建IPA文件夹
        createIpaDir()

        # 安装证书
        installCertificate()

        # 修改版本号
        modifyVersion()

        # 修改App显示名称
        modifyDisplayName()

        # 修改Bundle Id
        modifyBundleId()

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
        # file_recorder.do_rollback()

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

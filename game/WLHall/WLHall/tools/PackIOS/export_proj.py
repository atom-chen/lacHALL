#!/usr/bin/python
# encoding=utf-8
# 生成发给第三方的工程文件

import os
import sys
import time
import json
import shutil

default_encoding = 'utf-8'
if sys.getdefaultencoding() != default_encoding:
    reload(sys)
    sys.setdefaultencoding(default_encoding)

sys.path.append(os.path.normpath(os.path.join(os.path.dirname(__file__), '../utils')))
sys.path.append(os.path.normpath(os.path.join(os.path.dirname(__file__), '../ResEncrypt')))
from ResEncrypt import ResEncrypt
import excopy
import utils
from logUtils import Logging
from logUtils import raise_known_error
from logUtils import KnownError

sys.path.append(os.path.normpath(os.path.join(os.path.dirname(__file__), 'obscure')))
from modify_pbxproj import XcodeProject

from python_libs.Sed import Sed
from python_libs.Common import Common
from python_libs.Plist import Plist
from python_libs.FileUtils import FileUtils

class Generator(object):

    HALL_DIR_NAME = "WLHall"
    GAMES_DIR_NAME = "games"
    OUTPUT_PATH = "output"
    CERTS_DIR_NAME = "证书相关"
    ORI_PROJ_NAME = "WeiLeProjV3"
    ICONS_FOLDER = "WLHall/frameworks/runtime-src/proj.ios_mac/ios/Images.xcassets/AppIcon.appiconset"
    INFO_PLIST_PATH = "WLHall/frameworks/runtime-src/proj.ios_mac/ios/Info.plist"
    INFO_NOTIFY_PLIST_PATH = "WLHall/frameworks/runtime-src/proj.ios_mac/notificationService/Info.plist"
    XCODE_PROJ_PATH = "WLHall/frameworks/runtime-src/proj.ios_mac"
    CONTROLLER_PATH =  "WLHall/frameworks/runtime-src/proj.ios_mac/ios/AppController.mm"

    DEFAULT_HALL_DIRS = ['src', 'res']
    DEFAULT_GAMES_FOLDERS = [ "common", "mj_common" ]
    HALL_INCLUDE = [
        'frameworks/cocos2d-x', 'frameworks/libHall',
        'frameworks/runtime-src/AgoraSDK',
        'frameworks/runtime-src/Classes',
        'frameworks/runtime-src/Games',
        'frameworks/runtime-src/IM_SDK',
        'frameworks/runtime-src/library.chat.ios',
        'frameworks/runtime-src/proj.ios_mac'
    ]

    REMOVE_FLODERS = [
        'WLHall/frameworks/cocos2d-x/prebuilt',
        'WLHall/frameworks/libHall/prebuilt/android',
        'WLHall/frameworks/libHall/prebuilt/win32',
        'WLHall/frameworks/libHall/prebuilt/mac',
    ]

    CFG_KEY_GAME_NAME = 'game_name'
    CFG_KEY_PKG_NAME = 'pkg_name'
    CFG_KEY_VER_NAME = 'version_name'
    CFG_KEY_BUILD_NAME = 'build_name'
    CFG_KEY_APP_SCHEME = 'app_scheme'
    CFG_KEY_WEIXIN_ID = 'weixin_id'
    CFG_KEY_CERTS = 'certs'
    CFG_KEY_ICONS = 'icons'
    CFG_KEY_GAMES = 'games'
    CFG_KEY_EXTERNAL = 'external_resource'

    CFG_KEY_PROJ_NAME_NEW = 'proj_name_new'
    CFG_KEY_GETUI_APPID = 'getui_appId'
    CFG_KEY_GETUI_APPKEY = 'getui_appKey'
    CFG_KEY_GETUI_APPSECRET = 'getui_appSecret'
    CFG_KEY_TRACK_ID = 'track_id'
    CFG_KEY_REGION = 'region'

    CHECK_CFGS = [
        CFG_KEY_GAME_NAME,
        CFG_KEY_PKG_NAME,
        CFG_KEY_VER_NAME,
        CFG_KEY_BUILD_NAME,
        CFG_KEY_APP_SCHEME,
        CFG_KEY_WEIXIN_ID,
        CFG_KEY_CERTS,
        CFG_KEY_ICONS,
        CFG_KEY_GAMES,
        CFG_KEY_EXTERNAL,
        CFG_KEY_PROJ_NAME_NEW,
        CFG_KEY_GETUI_APPID,
        CFG_KEY_GETUI_APPKEY,
        CFG_KEY_GETUI_APPSECRET,
        CFG_KEY_TRACK_ID,
        CFG_KEY_REGION,
    ]

    # CFG_KEY_RESOURCES = 'resources'

    def __init__(self, args):
        cur_dir = os.path.dirname(__file__)
        self.proj_src_root = utils.flat_path(os.path.join(cur_dir, '../../../'))
        self.hall_root = os.path.join(self.proj_src_root, Generator.HALL_DIR_NAME)
        self.games_src_path = os.path.join(self.proj_src_root, Generator.GAMES_DIR_NAME)
        self.cfg_path = utils.flat_path(args.proj_cfg)
        self.cfg_root = os.path.dirname(self.cfg_path)
        self.config = self._parse_cfg()

    def _parse_cfg(self):
        ret = None
        try:
            f = open(self.cfg_path)
            ret = json.load(f)
            f.close()
        except:
            pass

        # 检查配置文件
        for k in Generator.CHECK_CFGS:
            Common.assertExit(ret.has_key(k), '未配置字段 ：%s' % k)

        self.game_name = ret[Generator.CFG_KEY_GAME_NAME]
        self.pkg_name = ret[Generator.CFG_KEY_PKG_NAME]
        self.ver_name = ret[Generator.CFG_KEY_VER_NAME]
        self.build_name = ret[Generator.CFG_KEY_BUILD_NAME]
        self.app_scheme = ret[Generator.CFG_KEY_APP_SCHEME]
        self.weixin_id = ret[Generator.CFG_KEY_WEIXIN_ID]
        self.games = ret[Generator.CFG_KEY_GAMES]
        self.certs = utils.flat_path(os.path.join(self.cfg_root, ret[Generator.CFG_KEY_CERTS]))
        self.icons = utils.flat_path(os.path.join(self.cfg_root, ret[Generator.CFG_KEY_ICONS]))
        self.external_res = utils.flat_path(os.path.join(self.cfg_root, ret[Generator.CFG_KEY_EXTERNAL]))

        self.proj_name_new = ret[Generator.CFG_KEY_PROJ_NAME_NEW]
        self.getui_appid = ret[Generator.CFG_KEY_GETUI_APPID]
        self.getui_appkey = ret[Generator.CFG_KEY_GETUI_APPKEY]
        self.getui_appsecret = ret[Generator.CFG_KEY_GETUI_APPSECRET]
        self.track_id = ret[Generator.CFG_KEY_TRACK_ID]
        self.region = ret[Generator.CFG_KEY_REGION]

        return ret

    def _get_new_proj_path(self, output_path):
        return os.path.join(output_path, Generator.XCODE_PROJ_PATH, '%s.xcodeproj' % self.proj_name_new)

    def _encrypt_files(self, output_path):
        temp_dir = os.path.join(self.cfg_root, 'temp')
        temp_assets_path = os.path.join(temp_dir, 'assets')
        if os.path.isdir(temp_assets_path):
            shutil.rmtree(temp_assets_path)
        os.makedirs(temp_assets_path)

        try:
            # 拷贝大厅的资源文件
            for p in Generator.DEFAULT_HALL_DIRS:
                copy_cfg = {
                    'from': p,
                    'to': p,
                    'exclude': [
                        '**/.DS_Store', '**/.git', 'LuaDebugjit.lua'
                    ]
                }
                excopy.copy_files_with_config(copy_cfg, self.hall_root, temp_assets_path)

            # 删除多余的地图资源
            self._delete_map_dir(temp_assets_path)

            # 拷贝 games 资源文件
            games_folders = []
            games_folders.extend(Generator.DEFAULT_GAMES_FOLDERS)
            games_folders.extend(self.games)
            for game in games_folders:
                copy_cfg = {
                    'from': '%s' % game,
                    'to': 'games/%s' % game,
                    'exclude': [
                        '**/.DS_Store',
                        '*.git'
                    ]
                }
                excopy.copy_files_with_config(copy_cfg, self.games_src_path, temp_assets_path)

            # 拷贝扩展资源文件
            copy_cfg = {
                'from': '.',
                'to': '.'
            }
            excopy.copy_files_with_config(copy_cfg, self.external_res, temp_assets_path)

            # 生成 native 环境信息文件
            utils.write_native_info(os.path.join(temp_assets_path, 'src/NativeInfo.lua'), {"no_agora": "true"})

            # 加密资源文件
            encrypt_info = {
                'games': {
                    'dst_path': 'games',
                    'exclude': [
                        'mj_common/images/card_packer/*.png'
                    ]
                },
                'src': 'WLHall/src',
                'res': 'WLHall/res'
            }

            for k in encrypt_info.keys():
                src_path = utils.flat_path(os.path.join(temp_assets_path, k))
                value = encrypt_info[k]
                if isinstance(value, str):
                    dst_path = utils.flat_path(os.path.join(output_path, value))
                    exclude = None
                else:
                    dst_path = utils.flat_path(os.path.join(output_path, value['dst_path']))
                    exclude = value['exclude']

                if os.path.isdir(dst_path):
                    shutil.rmtree(dst_path)

                encryptor = ResEncrypt(src_path, dst_path, False, exclude, True, False)
                encryptor.do_encrypt()
        except:
            raise
        finally:
            if os.path.isdir(temp_dir):
                shutil.rmtree(temp_dir)

    # 修改版本号
    def modifyVersion(self, info_plist_path, info_notify_plist_path):
        Common.runCmd(
            '/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString %s" %s' % (self.ver_name, info_plist_path))
        Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleVersion %s" %s' % (self.build_name, info_plist_path))

        # 修改个推版本号
        Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString %s" %s' % (self.ver_name, info_notify_plist_path))
        Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleVersion %s" %s' % (self.build_name, info_notify_plist_path))

    # 修改URLTypes
    def modifyURLTypes(self, info_plist_path):
        # 修改微信id
        urlName = Plist.getForKey(info_plist_path, "CFBundleURLTypes:0:CFBundleURLName")
        Common.assertBoolType(urlName == "wechatshceme", "info.plist的URL TYPES的第一个值必须是wechatshceme")
        weixinUrlScheme = self.weixin_id
        idsArray = weixinUrlScheme.split(",")
        Plist.resetArrayForKey(info_plist_path, "CFBundleURLTypes:0:CFBundleURLSchemes", idsArray)

        # 修改第三个值
        urlName = Plist.getForKey(info_plist_path, "CFBundleURLTypes:2:CFBundleURLName")
        Common.assertBoolType(urlName == "com.weile.www", "info.plist的URL TYPES的第三个值必须是com.weile.www")
        appScheme = self.app_scheme
        Plist.setForKey(info_plist_path, "CFBundleURLTypes:2:CFBundleURLSchemes:0", appScheme)

    # 修改App显示名称
    def modifyDisplayName(self, info_plist_path):
        cmd = '/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName %s" %s' % (self.game_name, info_plist_path)
        Common.runCmd(cmd)

    # 修改Bundle Id
    def modifyBundleId(self, info_plist_path, info_notify_plist_path, output_path):
        Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier %s" %s' % (self.pkg_name, info_plist_path))

        # 修改推送BundleId
        notifyPkgName = self.pkg_name + ".notifyService"
        Common.runCmd('/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier %s" %s' % (notifyPkgName, info_notify_plist_path))

        pbxproj_file = os.path.join(self._get_new_proj_path(output_path), 'project.pbxproj')
        pbx_obj = XcodeProject.Load(pbxproj_file)
        pbx_obj.set_target_build_setting('%s-mobile' % self.proj_name_new, 'PRODUCT_BUNDLE_IDENTIFIER', self.pkg_name)
        pbx_obj.set_target_build_setting('NotificationService', 'PRODUCT_BUNDLE_IDENTIFIER', notifyPkgName)
        # pbx_obj.set_target_build_setting('%s-mobile' % self.proj_name_new, 'APP_BUNDLE_IDENTIFIER', self.pkg_name)
        # pbx_obj.set_target_build_setting('NotificationService', 'EXTENSION_BUNDLE_IDENTIFIER', notifyPkgName)
        if (pbx_obj.modified):
            pbx_obj.save()

    def removeShellScript(self, output_path):
        pbxproj_file = os.path.join(self._get_new_proj_path(output_path), 'project.pbxproj')
        f = open(pbxproj_file)
        lines = f.readlines()
        f.close()

        new_lines = []
        pattern = '([ \t]*)shellScript = \".+\";'
        import re
        for line in lines:
            match = re.match(pattern, line)
            if match:
                new_lines.append('%sshellScript = "";\n' % match.group(1))
            else:
                new_lines.append(line)

        f = open(pbxproj_file, 'w')
        f.writelines(new_lines)
        f.close()

    # 创建一个新名字的 xcode 工程
    def createNewProj(self, output_path):
        proj_dir = os.path.join(output_path, Generator.XCODE_PROJ_PATH)
        srcDir = os.path.join(proj_dir, '%s.xcodeproj' % Generator.ORI_PROJ_NAME)
        dstDir = self._get_new_proj_path(output_path)
        FileUtils.copyDirctory(srcDir, dstDir)

        # delete the origin project dir
        FileUtils.removeDirectory(srcDir)

        # 拷贝配置文件
        srcFile = os.path.join(proj_dir, "%s-mobile.entitlements" % Generator.ORI_PROJ_NAME)
        Common.assertExit(os.path.isfile(srcFile), "文件 %s 不存在" % srcFile)
        dstFile = os.path.join(proj_dir, "%s-mobile.entitlements" % self.proj_name_new)
        FileUtils.copyFile(srcFile, dstFile)
        FileUtils.removeFile(srcFile)

        # 修改工程名字
        projFilePath = os.path.join(dstDir, 'project.pbxproj')
        Sed.replaceContent(Generator.ORI_PROJ_NAME, self.proj_name_new, projFilePath)

        # 移除临时文件
        for item in os.listdir(dstDir):
            full_path = os.path.join(dstDir, item)
            if full_path == projFilePath:
                continue

            if os.path.isdir(full_path):
                FileUtils.removeDirectory(full_path)
            elif os.path.isfile(full_path):
                FileUtils.removeFile(full_path)

    # 修改热云的 Track app key
    def modifyTrackID(self, output_path):
        if self.track_id == '':
            return

        filepath = os.path.join(output_path, Generator.CONTROLLER_PATH)
        target_str = r'trackingAppKey = @\"%s\"' % self.track_id
        Sed.replaceContent(r'trackingAppKey = @\".*\"', target_str, filepath)

    # 修改个推 id
    def modifyGetuiId(self, output_path):
        filepath = os.path.join(output_path, Generator.CONTROLLER_PATH)
        target_str = r'getuiAppId = @\"%s\"' % self.getui_appid
        Sed.replaceContent(r'getuiAppId = @\".*\"', target_str, filepath)
        target_str = r'getuiAppKey = @\"%s\"' % self.getui_appkey
        Sed.replaceContent(r'getuiAppKey = @\".*\"', target_str, filepath)
        target_str = r'getuiAppSecret = @\"%s\"' % self.getui_appsecret
        Sed.replaceContent(r'getuiAppSecret = @\".*\"', target_str, filepath)

    def _delete_map_dir(self, assets_path):
        region = self.region
        if region == 'all':
            return

        region_list = []
        new_list = region.split(',')
        for r in new_list:
            if r.strip() != '':
                region_list.append(r)

        # 超过1个地区时需要带上全国地图
        if len(region_list) > 1:
            region_list.append('0')

        keep_name_list = []
        for rid in region_list:
            keep_name = 'map_%s' % rid
            keep_name_list.append(keep_name)

        map_path = utils.flat_path(os.path.join(assets_path, 'res/hall/map'))
        if os.path.isdir(map_path):
            for f in os.listdir(map_path):
                full_path = os.path.join(map_path, f)
                if f not in keep_name_list and os.path.isdir(full_path):
                    shutil.rmtree(full_path)

            # 如果不显示全国地图，则删除云动画的图片
            if len(region_list) <= 1:
                cloud1_path = os.path.join(map_path, "yun1.png")
                cloud2_path = os.path.join(map_path, "yun2.png")
                os.remove(cloud1_path)
                os.remove(cloud2_path)

    def _modify_proj(self, output_path):
        info_plist_path = os.path.join(output_path, Generator.INFO_PLIST_PATH)
        info_notify_plist_path = os.path.join(output_path, Generator.INFO_NOTIFY_PLIST_PATH)
        # 修改版本号
        self.modifyVersion(info_plist_path, info_notify_plist_path)

        # 修改URL TYPES
        self.modifyURLTypes(info_plist_path)

        # 修改App显示名称
        self.modifyDisplayName(info_plist_path)

        # 修改Bundle Id
        self.modifyBundleId(info_plist_path, info_notify_plist_path, output_path)

        # 删除 shell script
        self.removeShellScript(output_path)

        # 修改热云的 Track app key
        self.modifyTrackID(output_path)

        # 修改个推的 appId appKey appSer
        self.modifyGetuiId(output_path)

    def do_generate(self):
        output_name = '%s_%s_%s' % (self.game_name, self.pkg_name, self.build_name)
        output_path = os.path.join(self.cfg_root, Generator.OUTPUT_PATH, output_name)
        if os.path.isdir(output_path):
            shutil.rmtree(output_path)
        os.makedirs(output_path)

        # 清理临时文件
        utils.run_shell('git clean -dfx', self.hall_root)

        # 拷贝大厅工程文件
        copy_cfg = {
            'from': '.',
            'to': '.',
            'include': Generator.HALL_INCLUDE
        }
        excopy.copy_files_with_config(copy_cfg, self.hall_root, os.path.join(output_path, Generator.HALL_DIR_NAME))

        # 删除不需要的文件夹
        for folder in Generator.REMOVE_FLODERS:
            full_path = os.path.join(output_path, folder)
            if os.path.isdir(full_path):
                shutil.rmtree(full_path)

        # 拷贝证书相关文件
        shutil.copytree(self.certs, os.path.join(output_path, Generator.CERTS_DIR_NAME))

        # 加密资源文件
        self._encrypt_files(output_path)

        # 创建新的工程
        self.createNewProj(output_path)

        # 修改工程配置
        self._modify_proj(output_path)

        # 拷贝 icon
        dst_icons = utils.flat_path(os.path.join(output_path, Generator.ICONS_FOLDER))
        copy_cfg = {
            'from': '.',
            'to': '.',
            'include': [ '*.png' ]
        }
        excopy.copy_files_with_config(copy_cfg, self.icons, dst_icons)

if __name__ == "__main__":
    from argparse import ArgumentParser
    parser = ArgumentParser(prog="gen_proj", description=utils.get_sys_encode_str("生成发给第三方的工程文件"))

    parser.add_argument("-c", "--cfg", dest="proj_cfg", required=True, help=utils.get_sys_encode_str("指定配置文件的路径。"))
    (args, unknown) = parser.parse_known_args()

    # record the start time
    begin_time = time.time()
    try:
        if len(unknown) > 0:
            raise_known_error('未知参数 : %s' % unknown, KnownError.ERROR_WRONG_ARGS)

        obj = Generator(args)
        obj.do_generate()
    except KnownError as e:
        # a known exception, exit with the known error number
        sys.exit(e.get_error_no())
    except Exception:
        raise
    finally:
        # output the spend time
        end_time = time.time()
        Logging.log_msg('\n总共用时： %.2f 秒\n' % (end_time - begin_time))

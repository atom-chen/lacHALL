#!/usr/bin/python
# encoding=utf-8
# 生成 apk 安装包

import os
import sys
import time
import datetime
import json
import shutil
import re
import traceback

from xml.dom import minidom

default_encoding = 'utf-8'
if sys.getdefaultencoding() != default_encoding:
    reload(sys)
    sys.setdefaultencoding(default_encoding)

sys.path.append(os.path.normpath(os.path.join(os.path.dirname(__file__), '../utils')))
import excopy
import utils
import SDKManager
from logUtils import Logging
from logUtils import raise_known_error
from logUtils import KnownError

# 配置文件格式：
# {
#   "132" : [ "200", "201" ],
#   "68" : [ "200" ],
#   ...
#   APP_ID : [ channel_id1, channel_id2 ]
# }
class PackAPK(object):
    ANT_CMD_FMT = '"%s" clean release -f "%s" -Dsdk.dir="%s" -Dkey.store="%s" -Dkey.alias=%s -Dkey.store.password=%s -Dkey.alias.password=%s'
    PKG_CFG_FILE_NAME = "package.json"

    CFG_GAME_NAME = 'game_name'
    CFG_PKG_NAME = 'pkg_name'
    CFG_BUGLY_ID = 'bugly_id'
    CFG_GAODE_KEY = 'gao_de_key'
    CFG_AGORA_ID = 'agora_id'
    CFG_VERSION_CODE = 'version_code'
    CFG_VERSION_NAME = 'version_name'
    CFG_GAMES = 'games'
    CFG_JAVA_RES = 'java_res'
    CFG_FILES = 'cfg_files'
    CFG_RES_FILES = 'res_files'
    CFG_SIGN = 'sign'
    CFG_SIGN_FILE = 'file'
    CFG_SIGN_PASSWORD = 'password'
    CFG_SIGN_ALIAS = 'alias'
    CFG_SIGN_ALIAS_PASSWORD = 'alias_password'
    CFG_SDKS = 'sdks'
    CFG_REMOVE_WEIXIN = 'remove_weixin'
    CFG_REMOVE_YOUQU = 'remove_youqu'
    CFG_APP_SCHEME = 'app_scheme'
    CFG_ONLY_HALL = 'only_hall'
    CFG_REMARK = 'remark'
    CFG_REGION = 'region'
    CFG_TURNOFF_PUSH = 'turnOffPush'
    CFG_GT_SDK = 'pushgetui'
    CFG_NO_AGORA = 'no_agora'
    CFG_GAME_COMMON_PARTS = "game_common_parts"

    CHECK_CFG_INFO = {
        CFG_GAME_NAME : { "type" : "string" },
        CFG_PKG_NAME : { "type" : "string" },
        CFG_GAODE_KEY : { "type" : "string" },
        CFG_VERSION_CODE: {"type": "string"},
        CFG_VERSION_NAME: {"type": "string"},
        CFG_JAVA_RES: {"type":"dir_list"},
        CFG_FILES: {"type": "dir_list"},
        CFG_GAME_COMMON_PARTS: {"type": "list"},
        CFG_APP_SCHEME: {"type": "string"},
        CFG_REGION: {"type": "string"},
        "%s.%s" % (CFG_SIGN, CFG_SIGN_FILE): {"type": "file"},
        "%s.%s" % (CFG_SIGN, CFG_SIGN_PASSWORD) : {"type": "string"},
        "%s.%s" % (CFG_SIGN, CFG_SIGN_ALIAS) : {"type": "string"},
        "%s.%s" % (CFG_SIGN, CFG_SIGN_ALIAS_PASSWORD) : {"type": "string"},
    }

    DEFAULT_HALL_DIRS = [ 'src', 'res' ]
    DEFAULT_GAMES_DIRS = [ 'common', 'mj_common' ]
    GAME_COMMON_PART_VALUES = [ 'common', 'mj_common', 'pk_common' ]
    NEED_BACKUP_ASSETS = []

    CHANGE_PKG_NAME_FILES = {
        "frameworks/runtime-src/library.weixin.android/AndroidManifest.xml" : {
            '".*\.wxapi\.WXEntryActivity"' : '"$NEW_NAME.wxapi.WXEntryActivity"',
            '".*\.wxapi\.WXPayEntryActivity"': '"$NEW_NAME.wxapi.WXPayEntryActivity"'
        }
    }

    # assets 文件夹加密过程中需要忽略的文件
    # 1. "games/mj_common/*.png" 因为已经是加密过的了，所以不需要再加密
    ASSETS_ENCRYPT_EXCLUDE_CFG = [
        "games/mj_common/images/card_packer/*.png"
    ]

    # agora 涉及到的库文件
    AGORA_LIBS = [
        "libs/agora-rtc-sdk.jar",
        "libs/AgoraCocos2dx.jar",
        "libs/armeabi-v7a/libagora-rtc-sdk-jni.so",
        "libs/armeabi-v7a/libapm-plugin-agora-cocos2dx.so"
    ]
    NO_AGORA_SO = "libs-no-agora/libwlgame.so"
    NO_AGORA_NEED_REPLACE_SO = "libs/armeabi-v7a/libwlgame.so"

    def __init__(self, args):
        self._check_env()

        self.batch_cfg_file = utils.flat_path(args.proj_cfg)
        if not os.path.isfile(self.batch_cfg_file):
            raise_known_error("文件 %s 不存在" % self.batch_cfg_file, KnownError.ERROR_PATH_NOT_FOUND)
        self.no_rollback = args.no_rollback
        self.no_encrypt = args.no_encrypt
        self.build_gradle = args.build_gradle
        self.root_dir = os.path.dirname(self.batch_cfg_file)
        self.temp_dir = os.path.join(self.root_dir, 'temp')
        cur_time_str = datetime.datetime.fromtimestamp(time.time()).strftime('%Y%m%d_%H%M%S')
        self.output_path = os.path.join(self.root_dir, 'output', cur_time_str)

        # 保存打包文件夹名称时间戳
        self.packageTimestamp = cur_time_str

        self.batch_info = self._parse_json(self.batch_cfg_file)
        if not self.batch_info:
            raise_known_error('解析文件 %s 失败' % self.batch_cfg_file, KnownError.ERROR_PARSE_FILE)

        cur_dir = os.path.dirname(__file__)
        self.proj_android_path = utils.flat_path(os.path.join(cur_dir, '../../frameworks/runtime-src/proj.android'))
        self.proj_androidStudio_path = utils.flat_path(os.path.join(cur_dir, '../../frameworks/runtime-src/proj.android-studio'))
        self.res_root_path = utils.flat_path(os.path.join(cur_dir, '../../'))
        self.games_root_path = utils.flat_path(os.path.join(self.res_root_path, '../games'))
        if not os.path.isdir(self.proj_android_path):
            raise_known_error("未找到 Android 工程文件夹 %s" % self.proj_android_path)

        self.library_android_path = utils.flat_path(os.path.join(cur_dir, '../../frameworks/runtime-src/library.android'))
        self.library_manifest = os.path.join(self.library_android_path, 'AndroidManifest.xml')

        self.manifest = os.path.join(self.proj_android_path, 'AndroidManifest.xml')
        self.strings = os.path.join(self.proj_android_path, 'res/values/strings.xml')
        self.build_xml = os.path.join(self.proj_android_path, 'build.xml')
        self.proj_name = self._get_proj_name()
        self.brand = args.brand

        self.java_files = []
        for parent, dirs, files in os.walk(utils.flat_path(os.path.join(self.proj_android_path, 'src'))):
            for f in files:
                filename, ext = os.path.splitext(f)
                if ext.lower() == '.java':
                    self.java_files.append(os.path.join(parent, f))

        Logging.debug_msg('使用配置文件 : %s' % self.batch_cfg_file)
        Logging.debug_msg('是否禁用加密 : %s' % self.no_encrypt)
        Logging.debug_msg('是否禁用还原 : %s' % self.no_rollback)
        Logging.debug_msg('Android 工程路径 : %s' % self.proj_android_path)
        Logging.debug_msg('----------------\n')

        self.build_result = {}

    def _check_env(self):
        self.ant_root = utils.check_environment_variable('ANT_ROOT')
        self.sdk_root = utils.flat_path(utils.check_environment_variable('ANDROID_SDK_ROOT'))
        self.ant_bin = utils.flat_path(os.path.join(self.ant_root, 'ant'))

    def _parse_json(self, json_file):
        ret = None
        try:
            f = open(json_file)
            ret = json.load(f)
            f.close()
        except:
            pass

        return ret

    def get_string(self, var):
        if isinstance(var, int):
            return '%d' % var

        return utils.non_unicode_str(var)

    def _check_gt_info(self, cfg_info, dir):
        ret = None
        # isTurnOffPush = cfg_info.get(PackAPK.CFG_TURNOFF_PUSH, None)
        # if (isTurnOffPush == "1"):
        #     return ret

        sdks = cfg_info.get(PackAPK.CFG_SDKS, {})
        gtsdk = sdks.get(PackAPK.CFG_GT_SDK, None)
        if (gtsdk is None):
            ret = "个推SDK未配置"

        return ret

    def _check_cfg_info(self, cfg_info, dir):
        ret = None
        for key in PackAPK.CHECK_CFG_INFO.keys():
            key_paths = key.split('.')
            check_info = PackAPK.CHECK_CFG_INFO[key]
            if len(key_paths) > 1:
                parent = cfg_info.get(key_paths[0], None)
                if (parent is None) or (not isinstance(parent, dict)):
                    ret = "配置文件中 %s 的值错误" % parent
                    break
                check_value = parent.get(key_paths[1], None)
            else:
                check_value = cfg_info.get(key, None)

            if check_value is None:
                ret = "配置文件中 %s 的值错误" % key
                break

            check_value = utils.non_unicode_str(check_value)
            if check_info["type"] == 'file':
                check_value = utils.flat_path(os.path.join(dir, check_value))
                if not os.path.isfile(check_value):
                    ret = "配置文件中 %s 的值并不是一个有效的文件" % key
                    break
            elif check_info["type"] == 'dir':
                check_value = utils.flat_path(os.path.join(dir, check_value))
                if not os.path.isdir(check_value):
                    ret = "配置文件中 %s 的值并不是一个有效的文件夹" % key
                    break
            elif check_info["type"] == 'dir_list':
                if not self._check_dir_list(dir, check_value):
                    ret = "配置文件中 %s 的值并不是一个有效的文件夹列表" % check_value
                    break
            elif check_info["type"] == 'list':
                if not isinstance(check_value, list):
                    ret = "配置文件中 %s 的值并不是一个有效的数组" % check_value
                    break
            else:
                if not isinstance(check_value, str):
                    ret = False
                    break

        return ret

    def _check_dir_list(self, dir, dir_list):
        ret = True
        check_list = dir_list.split(',')
        for p in check_list:
            check_value = utils.flat_path(os.path.join(dir, p.strip()))
            if not os.path.isdir(check_value):
                ret = False
                break

        return ret

    def _get_proj_name(self):
        doc_node = minidom.parse(self.build_xml)
        root_node = doc_node.getElementsByTagName('project')[0]
        return root_node.getAttribute('name')

    def _modify_java_files(self, new_pkg_name, rollback_obj):
        pattern = r'^import[ \t].*\.R;'
        for java in self.java_files:
            # 备份文件
            rollback_obj.record_file(java)
            f = open(java)
            lines = f.readlines()
            f.close()

            new_lines = []
            for line in lines:
                check_str = line.strip()
                match = re.match(pattern, check_str)
                if match:
                    line = 'import %s.R;\n' % new_pkg_name

                new_lines.append(line)

            f = open(java, 'w')
            f.writelines(new_lines)
            f.close()

    def _modify_bugly(self, manifest_file, bugly_id, channel_id):
        f = open(manifest_file)
        old_lines = f.readlines()
        f.close()

        patterns = {
            r'.*<meta-data android:name="BUGLY_APPID" android:value[ \t]*=[ \t]*"(.*)"' :  {
                'replaced' : False,
                'value' : bugly_id,
            },
            r'.*<meta-data android:name="BUGLY_APP_CHANNEL" android:value[ \t]*=[ \t]*"(.*)"' :  {
                'replaced' : False,
                'value' : channel_id,
            }
        }
        new_lines = []
        for line in old_lines:
            for pattern in patterns:
                pattern_info = patterns[pattern]
                if pattern_info['replaced']:
                    continue

                match = re.match(pattern, line)
                if match:
                    pattern_info['replaced'] = True
                    line = line.replace(match.group(1), pattern_info['value'])

            new_lines.append(line)

        f = open(manifest_file, 'w')
        f.writelines(new_lines)
        f.close()

    def _modify_gaode_key(self, manifest_file, gaode_key):
        f = open(manifest_file)
        old_lines = f.readlines()
        f.close()

        patterns = {
            r'.*<meta-data android:name="com.amap.api.v2.apikey" android:value[ \t]*=[ \t]*"(.*)"' :  {
                'replaced' : False,
                'value' : gaode_key,
            }
        }
        new_lines = []
        for line in old_lines:
            for pattern in patterns:
                pattern_info = patterns[pattern]
                if pattern_info['replaced']:
                    continue

                match = re.match(pattern, line)
                if match:
                    pattern_info['replaced'] = True
                    line = line.replace(match.group(1), pattern_info['value'])

            new_lines.append(line)

        f = open(manifest_file, 'w')
        f.writelines(new_lines)
        f.close()

    def _modify_agora_id(self, manifest_file, agora_id):
        f = open(manifest_file)
        old_lines = f.readlines()
        f.close()

        patterns = {
            r'.*<meta-data android:name="AGORA_APPID" android:value[ \t]*=[ \t]*"(.*)"' :  {
                'replaced' : False,
                'value' : agora_id,
            }
        }
        new_lines = []
        for line in old_lines:
            for pattern in patterns:
                pattern_info = patterns[pattern]
                if pattern_info['replaced']:
                    continue

                match = re.match(pattern, line)
                if match:
                    pattern_info['replaced'] = True
                    line = line.replace(match.group(1), pattern_info['value'])

            new_lines.append(line)

        f = open(manifest_file, 'w')
        f.writelines(new_lines)
        f.close()

    def _change_pkg_name(self, new_name, rollback_obj):
        for f in PackAPK.CHANGE_PKG_NAME_FILES:
            full_path = utils.flat_path(os.path.join(self.res_root_path, f))
            # 备份文件
            rollback_obj.record_file(full_path)
            f_obj = open(full_path)
            old_lines = f_obj.readlines()
            f_obj.close()

            new_lines = []
            info = PackAPK.CHANGE_PKG_NAME_FILES[f]
            for line in old_lines:
                new_line = line
                # 进行字符串替换
                for pattern in info:
                    new_str = info[pattern].replace('$NEW_NAME', new_name)
                    new_line = re.sub(pattern, new_str, new_line)
                new_lines.append(new_line)

            f_obj = open(full_path, 'w')
            f_obj.writelines(new_lines)
            f_obj.close()

    def _modify_manifest(self, pkg_name, ver_name, ver_code):
        f = open(self.manifest)
        old_lines = f.readlines()
        f.close()

        patterns = {
            r'.*package[ \t]*=[ \t]*\"(.*)\"' : {
                'replaced' : False,
                'value' : pkg_name,
            },
            r'.*android:versionCode[ \t]*=[ \t]*"(.*)"' :  {
                'replaced' : False,
                'value' : ver_code,
            },
            r'.*android:versionName[ \t]*=[ \t]*"(.*)"' :  {
                'replaced' : False,
                'value' : ver_name,
            },
        }
        new_lines = []
        for line in old_lines:
            for pattern in patterns:
                pattern_info = patterns[pattern]
                if pattern_info['replaced']:
                    continue

                match = re.match(pattern, line)
                if match:
                    pattern_info['replaced'] = True
                    line = line.replace(match.group(1), pattern_info['value'])

            new_lines.append(line)

        f = open(self.manifest, 'w')
        f.writelines(new_lines)
        f.close()

    def _modify_strings_xml(self, new_name, app_scheme):
        file_path = utils.flat_path(os.path.join(self.proj_android_path, 'res/values/strings.xml'))
        doc_node = minidom.parse(file_path)
        root_node = doc_node.getElementsByTagName('resources')[0]
        string_nodes = root_node.getElementsByTagName('string')
        for node in string_nodes:
            node_name = node.getAttribute('name')
            if node_name == 'app_name':
                node.firstChild.replaceWholeText(new_name.decode('utf-8'))

            if node_name == 'schemename':
                node.firstChild.replaceWholeText(app_scheme.decode('utf-8'))

        new_content = doc_node.toprettyxml(encoding='utf-8')
        # new_content 可能会出现空行，这里进行处理，删除空行
        lines = new_content.split('\n')
        new_lines = []
        for line in lines:
            if line.strip() != '':
                new_lines.append(line)

        f = open(file_path, 'w')
        f.write('\n'.join(new_lines))
        f.close()

    # 替换gradle参数
    def _modify_gradle_config(self, rollback_obj, out_file_path, apk_name, keyPath, keyPassword, alias, aliasPassword):
        file_path = utils.flat_path(os.path.join(self.proj_androidStudio_path, 'config.properties'))
        rollback_obj.record_file(file_path)
        f = open(file_path)
        old_lines = f.readlines()
        f.close()
        patterns = {
            r'.*OUTPUT_APK_DIR[ \t]*=[ \t]*(.*)' : {
                'replaced' : False,
                'value' : out_file_path,
            },
            r'.*OUTPUT_APK_NAME[ \t]*=[ \t]*(.*)' : {
                'replaced' : False,
                'value' : apk_name,
            },
            r'.*STORE_FILE[ \t]*=[ \t]*(.*)' : {
                'replaced' : False,
                'value' : keyPath,
            },
            r'.*STORE_PASSWORD[ \t]*=[ \t]*(.*)' : {
                'replaced' : False,
                'value' : keyPassword,
            },
            r'.*KEY_ALIAS[ \t]*=[ \t]*(.*)' : {
                'replaced' : False,
                'value' : alias,
            },
            r'.*KEY_PASSWORD[ \t]*=[ \t]*(.*)' : {
                'replaced' : False,
                'value' : aliasPassword,
            }
        }
        new_lines = []
        for line in old_lines:
            for pattern in patterns:
                pattern_info = patterns[pattern]
                if pattern_info['replaced']:
                    continue

                match = re.match(pattern, line)
                if match:
                    pattern_info['replaced'] = True
                    line = line.replace(match.group(1), pattern_info['value'])
            new_lines.append(line)

        f = open(file_path, 'w')
        f.writelines(new_lines)
        f.close()

    def _conv_rules(self, rules, type):
        ret = []
        for v in rules:
            check_str = 'games/%s/' % type
            if v.startswith(check_str):
                ret.append(v.replace(check_str, ''))

        return ret

    def _copy_game_common_parts(self, parts, assets_path):
        if not parts or len(parts) == 0:
            return

        for k in parts:
            if k not in PackAPK.GAME_COMMON_PART_VALUES:
                raise_known_error('game_common_parts 中配置 %s 无效' % k, KnownError.ERROR_WRONG_ARGS)

        if not os.path.isdir(self.games_root_path):
            raise_known_error('文件夹 %s 不存在' % self.games_root_path, KnownError.ERROR_PATH_NOT_FOUND)

        # 通用组件的文件划分配置文件
        cfg_file = utils.flat_path(os.path.join(self.games_root_path, "common/for-pack/pack-cfg.json"))
        if not os.path.isfile(cfg_file):
            raise_known_error('配置文件 %s 不存在' % cfg_file, KnownError.ERROR_PATH_NOT_FOUND)
        cfg_info = self._parse_json(cfg_file)
        base_exclude = [
            '**/.DS_Store',
            '*.git'
        ]

        cp_cfgs = []
        for k in parts:
            if k == "common":
                for d in PackAPK.DEFAULT_GAMES_DIRS:
                    exclude = []
                    exclude.extend(base_exclude)
                    exclude.extend(self._conv_rules(cfg_info['exclude'], d))
                    exclude.extend(self._conv_rules(cfg_info['pk_common']['include'], d))
                    exclude.extend(self._conv_rules(cfg_info['mj_common']['include'], d))
                    cp_cfgs.append({
                        'from': d,
                        'to': 'games/%s' % d,
                        'exclude': exclude
                    })
            else:
                for d in PackAPK.DEFAULT_GAMES_DIRS:
                    include = self._conv_rules(cfg_info[k]['include'], d)
                    if len(include) > 0:
                        cp_cfgs.append({
                            'from': d,
                            'to': 'games/%s' % d,
                            'include': include
                        })

        for c in cp_cfgs:
            excopy.copy_files_with_config(c, self.games_root_path, assets_path)

    def _do_encrypt(self, src, dst_path):
        Logging.debug_msg('开始资源加密')
        sys.path.append(os.path.normpath(os.path.join(os.path.dirname(__file__), '../ResEncrypt')))
        from ResEncrypt import ResEncrypt
        encryptor = ResEncrypt(src, dst_path, False, PackAPK.ASSETS_ENCRYPT_EXCLUDE_CFG, True, False)
        encryptor.do_encrypt()
        Logging.debug_msg('资源加密结束')

    def _do_remove_agora(self, rollback_obj):
        for f in PackAPK.AGORA_LIBS:
            agora_lib_path = utils.flat_path(os.path.join(self.library_android_path, f))
            if not os.path.isfile(agora_lib_path):
                raise_known_error('Agora 库文件: %s 不存在' % agora_lib_path, KnownError.ERROR_PATH_NOT_FOUND)

            # 记录库文件，方便回滚
            rollback_obj.record_file(agora_lib_path)
            # 删除库文件
            os.remove(agora_lib_path)

        # 需要替换 wlgame.so
        src_so = utils.flat_path(os.path.join(self.library_android_path, PackAPK.NO_AGORA_SO))
        if not os.path.isfile(src_so):
            raise_known_error('不包含 Agora 的库文件: %s 不存在' % src_so, KnownError.ERROR_PATH_NOT_FOUND)
        replace_so = utils.flat_path(os.path.join(self.library_android_path, PackAPK.NO_AGORA_NEED_REPLACE_SO))
        if not os.path.isfile(replace_so):
            raise_known_error('库文件: %s 不存在' % replace_so, KnownError.ERROR_PATH_NOT_FOUND)
        rollback_obj.record_file(replace_so)
        shutil.copy2(src_so, os.path.dirname(replace_so))

        # 需要修改 AppActivity.java 文件
        java_file = utils.flat_path(os.path.join(self.proj_android_path, "src/weile/games/AppActivity.java"))
        if not os.path.isfile(java_file):
            raise_known_error('文件 %s 不存在' % java_file, KnownError.ERROR_PATH_NOT_FOUND)

        rollback_obj.record_file(java_file)
        f = open(java_file)
        lines = f.readlines()
        f.close()
        pattern1 = "agora-rtc-sdk-jni"
        pattern2 = "apm-plugin-agora-cocos2dx"
        new_lines = []
        for l in lines:
            if l.find(pattern1) >= 0 or l.find(pattern2) >= 0:
                l = '// ' + l
            new_lines.append(l)

        f = open(java_file, 'w')
        f.writelines(new_lines)
        f.close()

    def build_apk_gradle(self, rollback_obj, cfg_dir, apk_cfg_info, apk_name):
        # 最终 apk 文件名格式为：GAMENAME_PKGNAME_APPID_CHANNELID_VERNAME_VERCODE.apk
        # Logging.debug_msg('修改apk文件名 game_name=%s pkg_name=%s app_id=%s channel_id=%s ver_name=%s ver_code=%s' % (game_name, pkg_name, app_id, channel_id, ver_name, ver_code))

        # 修改签名文件
        Logging.debug_msg('修改签名文件')
        keystore_path = utils.flat_path(os.path.join(cfg_dir, apk_cfg_info[PackAPK.CFG_SIGN][PackAPK.CFG_SIGN_FILE]))
        keystore_pass = apk_cfg_info[PackAPK.CFG_SIGN][PackAPK.CFG_SIGN_PASSWORD]
        alias = apk_cfg_info[PackAPK.CFG_SIGN][PackAPK.CFG_SIGN_ALIAS]
        alias_pass = apk_cfg_info[PackAPK.CFG_SIGN][PackAPK.CFG_SIGN_ALIAS_PASSWORD]
        self._modify_gradle_config(rollback_obj, self.output_path, apk_name, keystore_path, keystore_pass, alias, alias_pass)

        gradle_cmd = "cd %s;gradle clean;gradle aR" % self.proj_androidStudio_path
        try:
            utils.run_shell(gradle_cmd)
        except:
            Logging.warn_msg('gradle 命令行打包失败')

        Logging.debug_msg('gradle配置文件修改完成')

    def build_one_apk(self, app_id, channel_id, rollback_obj):
        apk_cfg_file = os.path.join(self.root_dir, app_id, channel_id, 'package.json')
        if not os.path.isfile(apk_cfg_file):
            Logging.warn_msg('未找到 %s 文件，打包失败' % apk_cfg_file)
            return

        Logging.debug_msg('开始使用配置文件 %s 打包' % apk_cfg_file)
        apk_cfg_info = self._parse_json(apk_cfg_file)
        if apk_cfg_info is None:
            Logging.warn_msg('解析文件 %s 出错，打包失败' % apk_cfg_file)
            return

        cfg_dir = os.path.dirname(apk_cfg_file)

        check_gt_ret = self._check_gt_info(apk_cfg_info, cfg_dir)
        if check_gt_ret:
            Logging.warn_msg(check_gt_ret + ', 打包失败')
            return

        check_ret = self._check_cfg_info(apk_cfg_info, cfg_dir)
        if check_ret:
            Logging.warn_msg(check_ret + ',打包失败')
            return

        # 备份文件和文件夹
        rollback_obj.record_file(utils.flat_path(self.library_manifest))
        rollback_obj.record_file(utils.flat_path(self.manifest))
        rollback_obj.record_folder(os.path.join(self.proj_android_path, 'res'))

        game_name = utils.non_unicode_str(apk_cfg_info[PackAPK.CFG_GAME_NAME])
        pkg_name = utils.non_unicode_str(apk_cfg_info[PackAPK.CFG_PKG_NAME])
        gaode_key = utils.non_unicode_str(apk_cfg_info[PackAPK.CFG_GAODE_KEY])
        ver_name = utils.non_unicode_str(apk_cfg_info[PackAPK.CFG_VERSION_NAME])
        ver_code = utils.non_unicode_str(apk_cfg_info[PackAPK.CFG_VERSION_CODE])
        app_scheme = utils.non_unicode_str(apk_cfg_info[PackAPK.CFG_APP_SCHEME])
        need_remove_agora = True # Android 去掉视频 SDK apk_cfg_info.get(PackAPK.CFG_NO_AGORA, False)

        # 修改 java 文件中 R 的包名
        self._modify_java_files(pkg_name, rollback_obj)

        # 对需要修改包名的文件进行包名替换
        self._change_pkg_name(pkg_name, rollback_obj)

        # 修改 bugly appid
        if apk_cfg_info.has_key(PackAPK.CFG_BUGLY_ID):
            bugly_appid = utils.non_unicode_str(apk_cfg_info[PackAPK.CFG_BUGLY_ID])
        else:
            bugly_appid = ""
        if len(bugly_appid) > 0:
            self._modify_bugly(self.library_manifest, bugly_appid, channel_id)

        # 修改高德 key
        if len(gaode_key) > 0:
            self._modify_gaode_key(self.library_manifest, gaode_key)

        # 修改 Agora id
        if apk_cfg_info.has_key(PackAPK.CFG_AGORA_ID):
            self._modify_agora_id(self.library_manifest, apk_cfg_info[PackAPK.CFG_AGORA_ID])

        # 修改 AndroidManifest.xml
        self._modify_manifest(pkg_name, ver_name, ver_code)

        # 替换 java res
        for p in apk_cfg_info[PackAPK.CFG_JAVA_RES].split(','):
            java_res_path = utils.flat_path(os.path.join(cfg_dir, p.strip()))
            copy_cfg = {
                'from': '.',
                'to': 'res',
                'exclude': [
                    '**/.DS_Store'
                ]
            }
            excopy.copy_files_with_config(copy_cfg, java_res_path, self.proj_android_path)

        # 替换 个推通知图标push.png
        # isTurnOffPush = apk_cfg_info.get(PackAPK.CFG_TURNOFF_PUSH, None)
        # if isTurnOffPush != "1":
        push_res_path = utils.flat_path(os.path.join(cfg_dir, "../pushRes"))
        proj_getui_path = utils.flat_path(os.path.join(self.proj_android_path, '../library.pushgetui.android'))
        if not os.path.isdir(proj_getui_path):
            raise_known_error("未找到 getui 工程文件夹 %s" % proj_getui_path)
        copy_cfg = {
            'from': '.',
            'to': 'res',
            'exclude': [
                '**/.DS_Store'
            ]
        }
        rollback_obj.record_folder(os.path.join(proj_getui_path, "res"))
        if os.path.isdir(push_res_path):
            excopy.copy_files_with_config(copy_cfg, push_res_path, proj_getui_path)
        else:
            # raise_known_error('文件夹 %s 不存在,放置个推通知图标pushRes/drawable-xxhdpi/push.png|push_small.png' % push_res_path, KnownError.ERROR_PATH_NOT_FOUND)
            res_path = utils.flat_path(os.path.join(self.proj_android_path, "res"))
            pushSmallSrc_path = utils.flat_path(os.path.join(res_path, "mipmap-hdpi/ic_launcher.png"))
            pushSrc_path = utils.flat_path(os.path.join(res_path, "mipmap-xxxhdpi/ic_launcher.png"))
            pushDes_path = utils.flat_path(os.path.join(proj_getui_path, "res/drawable-xxhdpi/push.png"))
            pushSmallDes_path = utils.flat_path(os.path.join(proj_getui_path, "res/drawable-xxhdpi/push_small.png"))
            # excopy.copy_files_with_config(copy_cfg, push_res_path, proj_getui_path)
            shutil.copyfile(pushSrc_path, pushDes_path)
            shutil.copyfile(pushSmallSrc_path, pushSmallDes_path)

        Logging.debug_msg('个推通知图标替换完成')

        # 修改 strings.xml
        self._modify_strings_xml(game_name, app_scheme)

        # 获取并清理临时的 assets 文件夹
        temp_assets_path = os.path.join(self.temp_dir, '%s_%s_assets' % (app_id, channel_id))
        if os.path.isdir(temp_assets_path):
            shutil.rmtree(temp_assets_path)

        Logging.debug_msg('开始处理资源文件')

        # 拷贝大厅的资源文件
        for p in PackAPK.DEFAULT_HALL_DIRS:
            copy_cfg = {
                'from': p,
                'to': p,
                'exclude': [
                    '**/.DS_Store',
                    'LuaDebugjit.lua'
                ]
            }
            excopy.copy_files_with_config(copy_cfg, self.res_root_path, temp_assets_path)

        # 拷贝游戏通用组件的各个部分
        game_common_parts = apk_cfg_info.get(PackAPK.CFG_GAME_COMMON_PARTS, None)
        self._copy_game_common_parts(game_common_parts, temp_assets_path)

        # 拷贝指定的游戏文件
        games_dirs = []
        games = apk_cfg_info.get(PackAPK.CFG_GAMES, None)
        if isinstance(games, list) and len(games) > 0:
            games_dirs.extend(games)

        if len(games_dirs) > 0:
            if not os.path.isdir(self.games_root_path):
                raise_known_error('文件夹 %s 不存在' % self.games_root_path, KnownError.ERROR_PATH_NOT_FOUND)

            for game in games_dirs:
                copy_cfg = {
                    'from': '%s' % game,
                    'to': 'games/%s' % game,
                    'exclude': [
                        '**/.DS_Store',
                        '*.git'
                    ]
                }
                excopy.copy_files_with_config(copy_cfg, self.games_root_path, temp_assets_path)

        # 替换游戏配置文件
        for p in apk_cfg_info[PackAPK.CFG_FILES].split(','):
            cfg_path = utils.flat_path(os.path.join(cfg_dir, p.strip()))
            copy_cfg = {
                'from': '.',
                'to': 'src',
                'exclude': [
                    '**/.DS_Store'
                ]
            }
            excopy.copy_files_with_config(copy_cfg, cfg_path, temp_assets_path)

        # cfg_package.lua文件末尾写入打包文件夹名称时间戳
        tmpFile = open(os.path.join(temp_assets_path, "src/cfg_package.lua"), 'a')
        tmpFile.write('\nPACKAGE_TIMESTAMP='+'\"' + self.packageTimestamp + '\"')
        tmpFile.close()

        # 替换 res 文件夹
        if apk_cfg_info.has_key(PackAPK.CFG_RES_FILES):
            for p in apk_cfg_info[PackAPK.CFG_RES_FILES].split(','):
                res_path = utils.flat_path(os.path.join(cfg_dir, p.strip()))
                copy_cfg = {
                    'from': '.',
                    'to': 'res',
                    'exclude': [
                        '**/.DS_Store'
                    ]
                }
                excopy.copy_files_with_config(copy_cfg, res_path, temp_assets_path)

        # 删除不需要的品牌资源文件夹
        for brand in utils.get_support_brands():
            brand_path = utils.flat_path(os.path.join(temp_assets_path, 'res', brand))
            if brand != self.brand and os.path.isdir(brand_path):
                shutil.rmtree(brand_path)

        # 删除不属于该地区的地图资源文件
        if apk_cfg_info.has_key(PackAPK.CFG_REGION) and apk_cfg_info[PackAPK.CFG_REGION] != 'all':
            region_list = []
            new_list = apk_cfg_info[PackAPK.CFG_REGION].split(',')
            for r in new_list:
                if r.strip() != '':
                    region_list.append(r)

            # 超过1个地区时需要带上全国地图
            if len(region_list) > 1:
                region_list.append('0')

            keep_name_list = []
            for region in region_list:
                keep_name = 'map_%s' % region
                keep_name_list.append(keep_name)

            map_path = utils.flat_path(os.path.join(temp_assets_path, 'res/hall/map'))
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

        # 清理 assets 文件夹，只保留需要的文件
        assets_path = os.path.join(self.proj_android_path, 'assets')
        file_recorder = utils.FileRollback()
        for f in PackAPK.NEED_BACKUP_ASSETS:
            file_recorder.record_file(utils.flat_path(os.path.join(assets_path, f)))
        if os.path.isdir(assets_path):
            shutil.rmtree(assets_path)
        if not self.no_rollback:
            file_recorder.do_rollback()

        # 进行加密或者直接拷贝资源文件
        if os.path.isdir(temp_assets_path):
            # 生成 native 环境信息文件
            params = None
            if need_remove_agora:
                # 需要移除 agora
                params = {"no_agora": "true"}
            utils.write_native_info(os.path.join(temp_assets_path, 'src/NativeInfo.lua'), params)
            if not self.no_encrypt:
                self._do_encrypt(temp_assets_path, assets_path)
            else:
                copy_cfg = {
                    'from': '.',
                    'to': '.',
                    'exclude': [
                        '**/.DS_Store'
                    ]
                }
                excopy.copy_files_with_config(copy_cfg, temp_assets_path, assets_path)
                f = open(os.path.join(assets_path, 'src/myflag'), 'w')
                f.write('')
                f.close()

        Logging.debug_msg('资源文件处理结束')

        # 处理 SDK 相关的配置
        Logging.debug_msg('处理 SDK 相关的配置开始')
        sdks_cfg = apk_cfg_info.get(PackAPK.CFG_SDKS, {})
        remove_weixin = apk_cfg_info.get(PackAPK.CFG_REMOVE_WEIXIN, False)
        remove_youqu = apk_cfg_info.get(PackAPK.CFG_REMOVE_YOUQU, False)
        sdk_mgr = SDKManager.SDKManager(rollback_obj, pkg_name, sdks_cfg, remove_weixin, remove_youqu, self.build_gradle, self.proj_android_path, self.proj_androidStudio_path)
        sdk_mgr.prepare_sdk()
        Logging.debug_msg('处理 SDK 相关的配置结束')

        # 检查是否需要删除 agora 的库文件
        if need_remove_agora:
            self._do_remove_agora(rollback_obj)

        # 最终 apk 文件名格式为：GAMENAME_PKGNAME_APPID_CHANNELID_VERNAME_VERCODE.apk
        Logging.debug_msg('生成apk文件名')
        name_infos = [pkg_name, app_id, channel_id, ver_name, ver_code]
        remark = utils.non_unicode_str(apk_cfg_info.get(PackAPK.CFG_REMARK, ""))
        if len(remark) is not 0:
            name_infos.append(remark)

        if self.no_encrypt:
            name_infos.append('NO_ENCRYPT')

        # 是否删除 agora
        # if need_remove_agora:
        #     name_infos.append("NO_AGORA")

        # 文件名增加时间戳
        Logging.debug_msg('文件名增加时间戳')
        cur_time_str = datetime.datetime.fromtimestamp(time.time()).strftime('%Y%m%d_%H%M%S')
        name_infos.append(cur_time_str)

        apk_name = '_'.join(name_infos) + '.apk'
        out_file_path = os.path.join(self.output_path, apk_name)
        if not os.path.isdir(self.output_path):
            os.makedirs(self.output_path)

        if self.build_gradle:
            # 进行 gradle 打包
            Logging.debug_msg('进行 gradle 打包')
            try:
                self.build_apk_gradle(rollback_obj, cfg_dir, apk_cfg_info, apk_name)
                self.build_result['%s_%s' % (app_id, channel_id)] = out_file_path
            except:
                print 'traceback.format_exc():\n%s' % traceback.format_exc()
                return
        else:
            # 进行 ant 打包
            Logging.debug_msg('进行 ant 打包')
            keystore_path = utils.flat_path(os.path.join(cfg_dir, apk_cfg_info[PackAPK.CFG_SIGN][PackAPK.CFG_SIGN_FILE]))
            keystore_pass = apk_cfg_info[PackAPK.CFG_SIGN][PackAPK.CFG_SIGN_PASSWORD]
            alias = apk_cfg_info[PackAPK.CFG_SIGN][PackAPK.CFG_SIGN_ALIAS]
            alias_pass = apk_cfg_info[PackAPK.CFG_SIGN][PackAPK.CFG_SIGN_ALIAS_PASSWORD]
            ant_cmd = PackAPK.ANT_CMD_FMT % (
                self.ant_bin, self.build_xml, self.sdk_root,
                keystore_path, alias, keystore_pass, alias_pass
            )
            try:
                utils.run_shell(ant_cmd)
            except:
                Logging.warn_msg('打包失败')
                return
            # 将 apk 包拷贝到指定位置
            build_path = utils.flat_path(os.path.join(self.proj_android_path, 'bin/%s-release.apk' % self.proj_name))
            shutil.copy(utils.get_sys_encode_str(build_path), utils.get_sys_encode_str(out_file_path))
            Logging.debug_msg('生成的 apk 文件路径：%s' % out_file_path)
            self.build_result['%s_%s' % (app_id, channel_id)] = out_file_path
        try:
            shutil.rmtree(temp_assets_path)
        except:
            pass

    def do_build(self):
        try:
            for app_id in self.batch_info.keys():
                app_id = utils.non_unicode_str(app_id)
                channels = self.batch_info[app_id]
                for channel_id in channels:
                    Logging.debug_msg('----------------')
                    apk_rollback_obj = utils.FileRollback()
                    try:
                        channel_str = self.get_string(channel_id)
                        self.build_result['%s_%s' % (app_id, channel_str)] = ''
                        self.build_one_apk(app_id, channel_str, apk_rollback_obj)
                    except:
                        Logging.warn_msg('打包失败')
                    finally:
                        if not self.no_rollback:
                            apk_rollback_obj.do_rollback()
                    Logging.debug_msg('----------------\n')

            Logging.debug_msg('\n打包结果汇总 :')
            for key in self.build_result.keys():
                ids = key.split('_')
                value = self.build_result[key]
                if value and os.path.isfile(utils.get_sys_encode_str(value)):
                    Logging.debug_msg('APP_ID : %s, CHANNEL_ID : %s。打包成功。apk 路径 : %s' % (ids[0], ids[1], value))
                else:
                    Logging.debug_msg('APP_ID : %s, CHANNEL_ID : %s。打包失败。' % (ids[0], ids[1]))

        except Exception:
            raise
        finally:
            if os.path.isdir(self.temp_dir):
                shutil.rmtree(self.temp_dir)

if __name__ == "__main__":
    from argparse import ArgumentParser
    parser = ArgumentParser(prog="PackAPK", description=utils.get_sys_encode_str("apk 安装包生成工具"))

    parser.add_argument("-c", "--cfg", dest="proj_cfg", required=True, help=utils.get_sys_encode_str("指定打包配置文件的路径。"))
    parser.add_argument("--no-encrypt", dest="no_encrypt", action='store_true', help=utils.get_sys_encode_str("若指定此参数，则不对资源文件进行加密。"))
    parser.add_argument("--no-rollback", dest="no_rollback", action='store_true', help=utils.get_sys_encode_str("若指定此参数，则不执行还原操作"))
    parser.add_argument("-b", dest='brand', choices=utils.get_support_brands(), default='weile', help=utils.get_sys_encode_str("指定当前打包的品牌，可选值为 weile，jixiang。默认为 weile"))

    #add by john, 添加gradle打包模式
    parser.add_argument("--build-gradle", dest="build_gradle", action='store_true', help=utils.get_sys_encode_str("若指定此参数，则使用gradle打包"))

    (args, unknown) = parser.parse_known_args()

    # record the start time
    begin_time = time.time()
    try:
        if len(unknown) > 0:
            raise_known_error('未知参数 : %s' % unknown, KnownError.ERROR_WRONG_ARGS)

        packer = PackAPK(args)
        packer.do_build()
    except KnownError as e:
        # a known exception, exit with the known error number
        sys.exit(e.get_error_no())
    except Exception:
        raise
    finally:
        # output the spend time
        end_time = time.time()
        Logging.log_msg('\n总共用时： %.2f 秒\n' % (end_time - begin_time))

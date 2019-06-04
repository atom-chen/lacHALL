# encoding=utf-8
# 管理 SDK

import os
import json
import shutil
import re
import sys

sys.path.append(os.path.normpath(os.path.join(os.path.dirname(__file__), '../utils')))
import excopy
import utils
from logUtils import raise_known_error
from logUtils import KnownError

class SDKManager(object):
    DEFAULT_LIBRARIES = [
        "../library.android",
        "../library.chat.android",
        "../library.weixin.android",
        "../library.h5.android",
        "../library.youqushare.android"
    ]

    def __init__(self, file_recorder, game_pkg_name, sdks_cfg, remove_weixin, remove_youqu, build_gradle, android_proj_path, android_studio_proj_path ):
        self.file_recorder = file_recorder
        self.sdks_cfg = sdks_cfg
        self.game_pkg_name = game_pkg_name
        self.remove_weixin = remove_weixin
        self.remove_youqu = remove_youqu
        self.android_proj_path = android_proj_path
        self.build_gradle = build_gradle
        self.project_properties = utils.flat_path(os.path.join(self.android_proj_path, 'project.properties'))
        self.config_gradle = utils.flat_path(os.path.join(android_studio_proj_path, 'app/config.gradle'))

    def prepare_sdk(self):
        if len(self.sdks_cfg.keys()) <= 0 and not self.remove_weixin:
            # 没有配置 SDK，也不需要移除微信
            return

        lib_projs = []
        lib_projs.extend(SDKManager.DEFAULT_LIBRARIES)
        remove_libs = []

        for sdk in self.sdks_cfg.keys():
            sdk_proj_path = '../library.%s.android' % sdk
            sdk_full_path = utils.flat_path(os.path.join(self.android_proj_path, sdk_proj_path))
            if not os.path.isdir(sdk_full_path):
                raise_known_error('SDK 文件夹 %s 不存在' % sdk_full_path, KnownError.ERROR_PATH_NOT_FOUND)

            sdk_obj = BaseSDK(self.file_recorder, self.game_pkg_name, self.sdks_cfg[sdk], sdk_full_path, self)
            sdk_obj.do_steps()
            remove_sdks = sdk_obj.get_remove_sdks()
            remove_libs.extend(remove_sdks)
            lib_projs.append(sdk_proj_path)

        if self.remove_weixin:
            remove_libs.append("weixin")
        for remove_lib in remove_libs:
            check_str = "../library.%s.android" % remove_lib
            if check_str in lib_projs:
                lib_projs.remove(check_str)

        if self.build_gradle:
            # 修改 config.gradle 文件
            self._modify_proj_gradle_config(lib_projs)
        else:
            # 修改 project.properties 文件
            self._modify_proj_properties(lib_projs)

    def _modify_proj_gradle_config(self, libs):
        self.file_recorder.record_file(self.config_gradle)

        f = open(self.config_gradle)
        old_lines = f.readlines()
        f.close()

        new_lines = []
        for line in old_lines:
            for lib in libs:
                # libStr = libs[lib]
                if lib in line:
                    line = line.lstrip("//")
            new_lines.append(line)

        f = open(self.config_gradle, 'w')
        f.writelines(new_lines)
        f.close()        

    def _modify_proj_properties(self, libs):
        # 备份 project.properties
        self.file_recorder.record_file(self.project_properties)

        f = open(self.project_properties)
        old_lines = f.readlines()
        f.close()

        new_lines = []
        for line in old_lines:
            if line.find('android.library.reference') < 0:
                new_lines.append(line)

        for i in range(len(libs)):
            new_lines.append('android.library.reference.%d=%s\n' % (i+1, libs[i]))

        f = open(self.project_properties, 'w')
        f.writelines(new_lines)
        f.close()

class BaseSDK(object):
    def __init__(self, file_recorder, game_pkg_name, cfg, proj_path, manager):
        self.file_recorder = file_recorder
        self.game_pkg_name = game_pkg_name
        self.cfg = cfg
        self.proj_path = proj_path
        sdk_cfg_path = utils.flat_path(os.path.join(proj_path, 'SDKConfig.json'))
        self.sdk_cfg = self._parse_cfg(sdk_cfg_path)
        self._remove_sdks = []
        self.manager = manager

    def _parse_cfg(self, cfg_path):
        if not os.path.isfile(cfg_path):
            raise_known_error('SDK 配置文件 %s 不存在' % cfg_path, KnownError.ERROR_PATH_NOT_FOUND)

        f = open(cfg_path)
        ret = json.load(f)
        f.close()

        return ret

    def get_remove_sdks(self):
        return self._remove_sdks

    def do_steps(self):
        for step in self.sdk_cfg:
            step_op = step['op']
            step_cfg = step['cfg']
            cmd = getattr(self, step_op)
            cmd(step_cfg)

    def check_cfg(self, cfg):
        if cfg is None or len(cfg) == 0:
            # 没有需要检查的配置
            return

        for value in cfg:
            if not self.cfg.has_key(value):
                raise_known_error('没有配置 %s' % value, KnownError.ERROR_WRONG_CONFIG)

    # 备份文件
    # 配置为数组，每个元素为相对于 sdk 文件夹的路径，如：
    # "cfg": [
    #     "./src",
    #     "./AndroidManifest.xml",
    #     "../library.android/libs/bugly_agent.jar"
    # ]
    def backup_files(self, cfg):
        for item in cfg:
            full_path = utils.flat_path(os.path.join(self.proj_path, item))
            if os.path.isdir(full_path):
                self.file_recorder.record_folder(full_path)
            elif os.path.isfile(full_path):
                self.file_recorder.record_file(full_path)

    # 拷贝文件
    # 配置为数组，每个元素包含 from 和 to 两个配置，都是相对于 sdk 文件夹的路径。
    # 在拷贝前会将 to 的配置中 $GAME_PKG_NAME 替换为游戏包名对应的路径。
    # 如：
    # "cfg": [
    #     {
    #         "from": "./assets",
    #         "to": "../proj.android/assets"
    #     }
    # ]
    def copy_files(self, cfg):
        game_pkg_path = self.game_pkg_name.replace('.', '/')
        for item in cfg:
            from_path = utils.flat_path(os.path.join(self.proj_path, item['from']))
            to_cfg = item['to']
            to_cfg = to_cfg.replace('$GAME_PKG_NAME', game_pkg_path)
            to_path = utils.flat_path(os.path.join(self.proj_path, to_cfg))

            if from_path == to_path:
                continue

            # 添加条件判断
            if item.has_key('condition'):
                copy_condition = item['condition']
                if not self.checkCondition(copy_condition):
                    continue

            copy_cfg = {
                "from": '.',
                "to": '.'
            }
            excopy.copy_files_with_config(copy_cfg, from_path, to_path)

    def checkCondition(self, copy_condition):
        ret = False
        if copy_condition.has_key('HAS_SDK'):
            condition_sdk = copy_condition['HAS_SDK']
            if self.manager.sdks_cfg.has_key(condition_sdk):
                ret = True
        return ret

    def _replace_cfg_vars(self, the_str):
        ret = the_str.replace('$GAME_PKG_NAME', self.game_pkg_name)
        for var in self.cfg.keys():
            var_flag = '$%s' % var.upper()
            ret = ret.replace(var_flag, self.cfg[var])

        return ret

    def _modify_file(self, file_path, replace_cfg):
        f = open(file_path)
        old_lines = f.readlines()
        f.close()

        new_lines = []
        for line in old_lines:
            new_line = line
            for pattern in replace_cfg.keys():
                target_str = replace_cfg[pattern]
                target_str = self._replace_cfg_vars(target_str)
                new_line = re.sub(pattern, target_str, new_line)
            new_lines.append(new_line)

        f = open(file_path, 'w')
        f.writelines(new_lines)
        f.close()

    # 修改文件
    # 配置为数组，每个元素包含 file 和 replace 两个配置。
    # file 为相对于 sdk 文件夹的路径
    # replace 为映射，key 为匹配字符串，可以使用正则表达式；value 为需要替换的字符串。
    # 在匹配的字符串被替换前，会先将 value 中 $SOME_VAR_NAME 格式的字符串替换为游戏配置中的 some_var_name 值。
    # $GAME_PKG_NAME 会被替换为游戏的包名字符串
    # 如：
    # "cfg": [
    #     {
    #         "file": "../proj.android/assets/ysdkconf.ini",
    #         "replace": {
    #             "QQ_APP_ID=.*$": "QQ_APP_ID=$QQ_APP_ID\n",
    #             "WX_APP_ID=.*$": "WX_APP_ID=$WX_APP_ID\n",
    #             "OFFER_ID=.*$": "OFFER_ID=$OFFER_ID\n"
    #         }
    #     },
    #     {
    #         "file": "./AndroidManifest.xml",
    #         "replace": {
    #             "data[ \\t]+android:scheme=\"[\\d]+\"": "data android:scheme=\"$QQ_APP_ID\"",
    #             "data[ \\t]+android:scheme=\"wx[\\w]+\"": "data android:scheme=\"$WX_APP_ID\""
    #         }
    #     }
    # ]
    def modify_files(self, cfg):
        for item in cfg:
            file_path = utils.flat_path(os.path.join(self.proj_path, item['file']))
            if not os.path.isfile(file_path):
                raise_known_error('%s 不存在' % file_path, KnownError.ERROR_PATH_NOT_FOUND)

            self._modify_file(file_path, item['replace'])

    # 删除文件/文件夹
    # 配置为数组，每个元素为相对于 sdk 文件夹的路径，如：
    # "cfg": [
    #     "../library.android/libs/bugly_agent.jar"
    # ]
    def remove_files(self, cfg):
        for item in cfg:
            full_path = utils.flat_path(os.path.join(self.proj_path, item))
            if os.path.isfile(full_path):
                os.remove(full_path)
            elif os.path.isdir(full_path):
                shutil.rmtree(full_path)

    # 移动文件/文件夹
    # 配置为数组，每个元素包含 from 和 to 两个配置，都是相对于 sdk 文件夹的路径。
    # 在拷贝前会将 to 的配置中 $GAME_PKG_NAME 替换为游戏包名对应的路径。
    # 如：
    # "cfg": [
    #     {
    #         "from": "./src/com/tencent/tmgp/weile/nbmaj/wxapi",
    #         "to": "./src/$GAME_PKG_NAME/wxapi"
    #     }
    # ]
    def move_files(self, cfg):
        game_pkg_path = self.game_pkg_name.replace('.', '/')
        for item in cfg:
            from_path = utils.flat_path(os.path.join(self.proj_path, item['from']))
            to_cfg = item['to']
            to_cfg = to_cfg.replace('$GAME_PKG_NAME', game_pkg_path)
            to_path = utils.flat_path(os.path.join(self.proj_path, to_cfg))

            if from_path == to_path:
                # 源目录和目标目录一致，不需要处理
                continue

            # 拷贝文件/文件夹，然后删除原始文件
            if os.path.isdir(from_path):
                copy_cfg = {
                    "from": '.',
                    "to": '.'
                }
                excopy.copy_files_with_config(copy_cfg, from_path, to_path)
                shutil.rmtree(from_path)
            elif os.path.isfile(from_path):
                shutil.copy2(from_path, to_path)
                os.remove(from_path)

    def remove_sdks(self, cfg):
        self._remove_sdks.extend(cfg)

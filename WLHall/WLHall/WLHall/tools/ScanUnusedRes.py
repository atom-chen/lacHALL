#!/usr/bin/python
# encoding=utf-8
# 扫描未使用的图片资源

import os
import sys
import time
import plistlib
import shutil

sys.path.append(os.path.normpath(os.path.join(os.path.dirname(__file__), './utils')))
import utils
from logUtils import Logging
from logUtils import raise_known_error
from logUtils import KnownError

RES_FOLDERS = [ 'res' ]
RES_TYPES = [ '.png', '.jpg', '.mp3', '.plist', '.fnt' ]
STUDIO_PROJ_FOLDERS = [ 'cocosstudio_hall/cocosstudio' ]

PUBLISH_RES_FOLDER = 'res'
CHECK_FOLDERS = [ 'src', 'res' ]
CHECK_FILE_TYPES = [ '.lua' ]

class Scanner(object):
    def __init__(self, args):
        self.delete = args.do_delete
        cur_dir = os.path.dirname(__file__)
        self.res_root_path = utils.flat_path(os.path.join(cur_dir, '../'))
        self.check_files = {}

    def _do_delete(self):
        pass

    def _do_add_check_files(self, key, value):
        unix_key = key.replace('\\', '/')

        if unix_key not in self.check_files:
            self.check_files[unix_key] = value
        else:
            Logging.warn_msg("%s 冲突：%s 和 %s" % (unix_key, self.check_files[unix_key], value))

    def _parse_plist(self, plist_path, relative_path):
        pl = plistlib.readPlist(plist_path)
        if not pl.has_key('frames'):
            return

        # 先将 plist 加入检查
        self._do_add_check_files(relative_path, plist_path)

        frames = pl["frames"]
        for key in frames:
            self._do_add_check_files(key, '%s#%s' % (plist_path, key))

    def do_scan(self):
        # 获取需要检测的文件路径字符串
        types_count = {}
        Logging.debug_msg("---- 开始扫描所有资源文件 ----")
        for folder in RES_FOLDERS:
            check_folder = utils.flat_path(os.path.join(self.res_root_path, folder))
            for parent, dirs, files in os.walk(check_folder):
                for f in files:
                    base_name, ext = os.path.splitext(f)
                    full_path = os.path.join(parent, f)
                    relative_path = os.path.relpath(full_path, check_folder)

                    if ext in RES_TYPES:
                        # 统计资源数量
                        if types_count.has_key(ext):
                            types_count[ext] += 1
                        else:
                            types_count[ext] = 1

                        if ext == '.plist':
                            self._parse_plist(full_path, relative_path)
                        else:
                            find_path = relative_path
                            if ext == '.png':
                                # png 可能是合图或者 fnt 字体，跳过
                                plist_path = os.path.join(parent, base_name + '.plist')
                                fnt_path = os.path.join(parent, base_name + '.fnt')
                                if os.path.isfile(plist_path) or os.path.isfile(fnt_path):
                                    find_path = None

                            if find_path:
                                self._do_add_check_files(find_path, full_path)

        for folder in STUDIO_PROJ_FOLDERS:
            studio_folder = utils.flat_path(os.path.join(self.res_root_path, folder))
            for parent, dirs, files in os.walk(studio_folder):
                for f in files:
                    base_name, ext = os.path.splitext(f)
                    full_path = os.path.join(parent, f)

                    if ext == '.csd':
                        if types_count.has_key(ext):
                            types_count[ext] += 1
                        else:
                            types_count[ext] = 1

                        relative_path = os.path.relpath(full_path, studio_folder)
                        relative_lua  = os.path.join(os.path.dirname(relative_path), base_name + '.lua')
                        lua_path = os.path.join(self.res_root_path, PUBLISH_RES_FOLDER, relative_lua)
                        if not os.path.isfile(lua_path):
                            # 发布的 lua 文件已经不存在了，不需要检查
                            continue

                        csd_lua_file = base_name + '.lua'
                        self._do_add_check_files(csd_lua_file, full_path)

                        # 还需要加入 a.b.c 的检查
                        require_key = os.path.join(os.path.dirname(relative_path), base_name)
                        require_key = require_key.replace('/', '.')
                        require_key = require_key.replace('\\', '.')
                        self._do_add_check_files(require_key, full_path)

        Logging.debug_msg("\n")
        for ext in types_count:
            Logging.debug_msg("%s files: %d" % (ext, types_count[ext]))
        Logging.debug_msg("---- 扫描资源文件结束 %d ----\n" % len(self.check_files))

        # Logging.debug_msg('need check files (%d):' % len(check_files))
        # for key in check_files:
        #     Logging.debug_msg('%s : %s' % (key, check_files[key]))


        # 读取需要检查的 lua 文件内容
        lua_files_info = {}
        for folder in CHECK_FOLDERS:
            check_folder = utils.flat_path(os.path.join(self.res_root_path, folder))
            for parent, dirs, files in os.walk(check_folder):
                for f in files:
                    base_name, ext = os.path.splitext(f)
                    full_path = os.path.join(parent, f)
                    if ext in CHECK_FILE_TYPES:
                        # 读取文件内容
                        f = open(full_path)
                        content = f.read()
                        f.close()
                        lua_files_info[full_path] = content

        # 进行检查
        self.unused = []
        self.used = []
        for key in self.check_files:
            tip_str = self.check_files[key]
            if tip_str in self.used:
                # 之前已经找到使用的地方了，直接跳过
                continue

            used = False
            for content_key in lua_files_info:
                content = lua_files_info[content_key]
                if content.find(key) >= 0:
                    used = True
                    break

            if used:
                self.used.append(tip_str)
                if tip_str in self.unused:
                    # 从 unused 中移除
                    self.unused.remove(tip_str)
            else:
                if tip_str not in self.unused:
                    # 之前未找到过，记录下来
                    self.unused.append(tip_str)

        # 输出未使用的文件
        Logging.debug_msg("未使用的文件(%d)：" % len(self.unused))
        unused_temp_path = utils.flat_path('~/Downloads/unused_files')
        if os.path.isdir(unused_temp_path):
            shutil.rmtree(unused_temp_path)
        os.makedirs(unused_temp_path)
        self.unused = sorted(self.unused)
        for f in self.unused:
            Logging.debug_msg(f)
            if f.find('#') <= 0:
                shutil.copy2(f, unused_temp_path)

        if self.delete:
            self._do_delete()

if __name__ == "__main__":
    from argparse import ArgumentParser
    parser = ArgumentParser(prog="ScanUnusedRes", description=utils.get_sys_encode_str("扫描未使用的图片资源"))
    parser.add_argument("--do-delete", dest="do_delete", action='store_true', help=utils.get_sys_encode_str("慎用！！！若指定此参数，则未使用的资源将被删除。"))

    (args, unknown) = parser.parse_known_args()

    # record the start time
    begin_time = time.time()
    try:
        if len(unknown) > 0:
            raise_known_error('未知参数 : %s' % unknown, KnownError.ERROR_WRONG_ARGS)

        scanner = Scanner(args)
        scanner.do_scan()
    except KnownError as e:
        # a known exception, exit with the known error number
        sys.exit(e.get_error_no())
    except Exception:
        raise
    finally:
        # output the spend time
        end_time = time.time()
        Logging.log_msg('\n总共用时： %.2f 秒\n' % (end_time - begin_time))

#!/usr/bin/python
# encoding=utf-8
# 生成地区的新版本 ufd

import os
import sys
import time
import re

from xml.dom import minidom

sys.path.append(os.path.normpath(os.path.join(os.path.dirname(__file__), './utils')))
import utils
from logUtils import Logging
from logUtils import raise_known_error
from logUtils import KnownError

class NewUfdGenerator(object):

    KEEP_RULES = [
        "./games/*",
        "./src/areaconfig.lua",
        "./src/cfg_game.lua",
        "./src/cfg_package.lua",
        "./src/hallconfig.lua",
        "./src/manifest.lua",
        "./res/hall/map/*"
    ]

    XML_ROOT_NAME = 'UpdateProject'
    XML_FILE_NODE_NAME = 'FILE'
    XML_NAME_ATTR = 'name'

    def __init__(self, args):
        self.src_file = utils.flat_path(args.src_file)
        if not os.path.isfile(self.src_file):
            raise_known_error('文件 %s 不存在' % self.src_file, KnownError.ERROR_PATH_NOT_FOUND)

        if args.dst_file:
            self.dst_file = utils.flat_path(args.dst_file)
        else:
            name, ext = os.path.splitext(self.src_file)
            self.dst_file = '%s_new%s' % (name, ext)

        Logging.debug_msg("原始文件路径：%s" % self.src_file)
        Logging.debug_msg("输出文件路径：%s" % self.dst_file)

    def _is_keep_path(self, path):
        rules = utils.convert_rules(NewUfdGenerator.KEEP_RULES)
        for rule in rules:
            if re.match(rule, path):
                return True

        return False

    def _get_node_attr(self, node, attr_name):
        ret = node.getAttribute(attr_name)
        return utils.non_unicode_str(ret)

    def save_ufd(self):
        new_content = self.doc_node.toprettyxml(encoding='utf8')
        # new_content 可能会出现空行，这里进行处理，删除空行
        lines = new_content.split('\n')
        new_lines = []
        for line in lines:
            if line.strip() != '':
                new_lines.append(line)

        f = open(self.dst_file, 'w')
        f.write('\n'.join(new_lines))
        f.close()

    def do_gen(self):
        self.doc_node = minidom.parse(self.src_file)
        self.root_node = self.doc_node.getElementsByTagName(NewUfdGenerator.XML_ROOT_NAME)[0]

        nodes = self.root_node.getElementsByTagName(NewUfdGenerator.XML_FILE_NODE_NAME)
        for node in nodes:
            node_path = self._get_node_attr(node, NewUfdGenerator.XML_NAME_ATTR)
            if not self._is_keep_path(node_path):
                self.root_node.removeChild(node)

        self.save_ufd()

if __name__ == "__main__":
    from argparse import ArgumentParser
    parser = ArgumentParser(prog="GenNewUfd", description=utils.get_sys_encode_str("生成新版本的 ufd"))
    parser.add_argument("-s", dest="src_file", required=True, help=utils.get_sys_encode_str("指定原 ufd 文件路径"))
    parser.add_argument("-d", dest="dst_file", help=utils.get_sys_encode_str("指定目标 ufd 文件路径"))

    (args, unknown) = parser.parse_known_args()

    # record the start time
    begin_time = time.time()
    try:
        if len(unknown) > 0:
            raise_known_error('未知参数 : %s' % unknown, KnownError.ERROR_WRONG_ARGS)

        generator = NewUfdGenerator(args)
        generator.do_gen()
    except KnownError as e:
        # a known exception, exit with the known error number
        sys.exit(e.get_error_no())
    except Exception:
        raise
    finally:
        # output the spend time
        end_time = time.time()
        Logging.log_msg('\n总共用时： %.2f 秒\n' % (end_time - begin_time))

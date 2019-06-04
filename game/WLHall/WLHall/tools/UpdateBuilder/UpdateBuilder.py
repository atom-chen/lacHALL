#!/usr/bin/python
# encoding=utf-8
# 生成热更新包

import os
import sys
import time
import hashlib
import datetime
import shutil

from xml.dom import minidom

sys.path.append(os.path.normpath(os.path.join(os.path.dirname(__file__), '../utils')))

import excopy
import utils
from logUtils import Logging
from logUtils import raise_known_error
from logUtils import KnownError

class UpdateBuilder(object):

    XML_ROOT_NAME = 'UpdateProject'
    XML_FILE_NODE_NAME = 'FILE'

    # project 属性
    XML_WORK_DIR_ATTR = 'dir'
    XML_LUA_PARAM_ATTR = 'luaparam'

    # File 节点属性
    XML_NAME_ATTR = 'name'
    XML_HASH_ATTR = 'hash'
    XML_OP_ATTR = 'op'
    XML_SIZE_ATTR = 'size'
    XML_VERSION_ATTR = 'version'

    INIT_UFD_VERSION = 0

    FULL_PKG_VERSION = 0

    OP_ADD = 0
    OP_DEL = 1
    OP_REN = 2
    OP_CLOSE = 3
    OP_RUN = 4

    OUTPUT_DIR_NAME = 'output'
    TEMP_DIR_NAME = 'temp'
    WORK_DIR_NAME = 'work-dir'

    HALL_MANIFEST_PATH = 'src/manifest.lua'
    HALL_MANIFEST_CONTENT_FMT = '''-- 版本信息清单文件
return {
	version={%s},
	extfile="src/hallconfig.lua",
	cmd="print(\\"------this is hall manifest print info -------\\")"
}
'''

    # 文件夹加密过程中需要忽略的文件
    # 1. "games/mj_common/*.png" 因为已经是加密过的了，所以不需要再加密
    ASSETS_ENCRYPT_EXCLUDE_CFG = [
        "games/mj_common/images/card_packer/*.png"
    ]

    def __init__(self, args):
        self.do_save = args.do_save
        self.no_pack = args.no_pack
        self.no_encrypt = args.no_encrypt
        self.out_name = args.out_name
        self.brand = args.brand
        self.region = None
        if self._is_handle_hall():
            if args.region is None:
                raise_known_error("没有配置 --region 参数", KnownError.ERROR_WRONG_ARGS)
            if args.region != 'all':
                self.region = args.region

        if (not self.no_pack) and (not self.out_name):
            # 如果要打更新包的话，必须指定 --out-name 参数
            raise_known_error("未指定 --out-name 参数", KnownError.ERROR_WRONG_ARGS)

        self.proj_cfg = utils.flat_path(args.proj_cfg)

        self.lua_param = args.lua_param
        self.min_ver = int(args.min_ver) if args.min_ver else 1
        self.cur_version = None
        if args.cur_ver:
            self.cur_version = int(args.cur_ver)
        elif self.out_name:
            # 指定了 --out-name 参数，从中解析版本号
            ver_arr = self.out_name.split('.')
            if len(ver_arr) == 3:
                # 是大厅版本，取最后一位
                self.cur_version = int(ver_arr[2])
            else:
                # 是游戏版本，直接转换
                self.cur_version = int(self.out_name)

        self.ver_ext_cfg = None
        if args.ver_ext_cfg:
            self.ver_ext_cfg_path = utils.flat_path(args.ver_ext_cfg)
            self.ver_ext_cfg = utils.parse_json(self.ver_ext_cfg_path)

        self.src_path = self._gen_src_path(args.src)
        if not os.path.isfile(self.proj_cfg):
            Logging.debug_msg('%s 文件不存在，进行初始化。' % self.proj_cfg)
            self.doc_node = minidom.Document()
            self.root_node = self.doc_node.createElement(UpdateBuilder.XML_ROOT_NAME)

            if self.cur_version is None:
                # 未指定版本号，使用默认版本号 + 1
                # self.cur_version = UpdateBuilder.INIT_UFD_VERSION + 1
                raise_known_error('未指定当前版本（ --cur-ver 或者 --out-name 参数）')

            self.root_node.setAttribute(UpdateBuilder.XML_VERSION_ATTR, '%d' % UpdateBuilder.INIT_UFD_VERSION)

            if self.lua_param:
                self.root_node.setAttribute(UpdateBuilder.XML_LUA_PARAM_ATTR, self.lua_param)

            self.doc_node.appendChild(self.root_node)
            self.save_ufd()
        else:
            self.doc_node = minidom.parse(self.proj_cfg)
            self.root_node = self.doc_node.getElementsByTagName(UpdateBuilder.XML_ROOT_NAME)[0]

            if self.cur_version is None:
                self.cur_version = int(self._get_node_attr(self.root_node, UpdateBuilder.XML_VERSION_ATTR)) + 1

            if self.lua_param is None:
                self.lua_param = self._get_node_attr(self.root_node, UpdateBuilder.XML_LUA_PARAM_ATTR)
            else:
                self.root_node.setAttribute(UpdateBuilder.XML_LUA_PARAM_ATTR, self.lua_param)

        self.encrypt_exclude_cfg = None
        if args.encrypt_exclude_cfg:
            self.encrypt_exclude_cfg = utils.flat_path(args.dump_exclude_cfg)
            if not os.path.isfile(self.encrypt_exclude_cfg):
                raise_known_error('%s 文件不存在' % self.encrypt_exclude_cfg, KnownError.ERROR_PATH_NOT_FOUND)

        self.exclude_cfg = None
        if args.exclude_cfg:
            self.exclude_cfg = utils.parse_rules_cfg(args.exclude_cfg)

    def _is_handle_hall(self):
        if not self.out_name:
            return False

        ver_arr = self.out_name.split('.')
        return len(ver_arr) == 3

    def _gen_src_path(self, src_paths):
        src_info = []
        for src in src_paths:
            cfg_list = src.split(';')
            if len(cfg_list) > 2:
                raise_known_error('参数 %s 格式错误！' % src, KnownError.ERROR_WRONG_ARGS)

            if len(cfg_list) == 1:
                full_path = utils.flat_path(src)
                dst_path = os.path.basename(src)
            else:
                full_path = utils.flat_path(cfg_list[0])
                dst_path = cfg_list[1]

            if not os.path.isdir(full_path) and not os.path.isfile(full_path):
                raise_known_error(' %s 不存在' % full_path, KnownError.ERROR_PATH_NOT_FOUND)

            src_info.append({
                'src_path' : full_path,
                'dst_path' : dst_path
            })

        # 考虑到 windows 跨盘符拷贝时间较长，这里将临时工作目录放到工程文件的同级目录下
        ret = self._create_temp_dir(UpdateBuilder.WORK_DIR_NAME)
        Logging.debug_msg("---- 开始构建工作目录 ----")
        for info in src_info:
            # 拷贝文件到指定位置
            src_path = info['src_path']
            dst_path = utils.flat_path(os.path.join(ret, info['dst_path']))
            Logging.debug_msg("---- 将 %s 拷贝到 %s ----" % (src_path, dst_path))
            if os.path.isfile(src_path):
                dst_dir = os.path.dirname(dst_path)
                if not os.path.isdir(dst_dir):
                    os.makedirs(dst_dir)
                shutil.copyfile(src_path, dst_path)
            else:
                cfg = {
                    "from": src_path,
                    "to": dst_path,
                    "exclude": [
                        "*/.DS_Store",
                        "LuaDebugjit.lua"
                    ]
                }
                excopy.copy_files_with_config(cfg, src_path, dst_path)

        # 如果有版本扩展配置，需要进行相应处理
        if self.ver_ext_cfg:
            cfg_root_path = os.path.dirname(self.ver_ext_cfg_path)
            for i in range(self.cur_version + 1):
                ver_key = "%d" % i
                if self.ver_ext_cfg.has_key(ver_key):
                    cfg_v = self.ver_ext_cfg[ver_key]
                    if cfg_v.has_key("do_file"):
                        cfg_do_file = cfg_v["do_file"]
                        srcfile = os.path.join(cfg_root_path, cfg_do_file["srcfile"])
                        dstpath = utils.flat_path(os.path.join(ret, cfg_do_file["dstpath"]))
                        if not os.path.exists(dstpath):
                            os.makedirs(dstpath)
                        shutil.copy(srcfile, dstpath)

        # 删除不属于该地区的地图资源文件
        if self.region is not None:
            region_list = []
            new_region = self.region.split(',')
            for r in new_region:
                if r.strip() != '':
                    region_list.append(r)

            if len(region_list) > 0:
                if len(region_list) > 1:
                    region_list.append(0)

                keep_name_list = []
                for r in region_list:
                    keep_name = 'map_%s' % r
                    keep_name_list.append(keep_name)

                map_path = utils.flat_path(os.path.join(ret, 'res/hall/map'))
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

        Logging.debug_msg("---- 构建工作目录结束 ----\n")

        if self.out_name:
            hall_vers = self.out_name.split('.')
            if len(hall_vers) == 3:
                # 是大厅的热更新包生成，需要写一个 manifest.lua 文件到 src 文件夹
                self._gen_hall_manifest(hall_vers, ret)

                # 大厅的热更新包，需要删除不需要的品牌资源文件夹
                for brand in utils.get_support_brands():
                    brand_path = utils.flat_path(os.path.join(ret, 'res', brand))
                    if brand != self.brand and os.path.isdir(brand_path):
                        shutil.rmtree(brand_path)
        return ret

    def _gen_hall_manifest(self, hall_vers, root_path):
        manifest_path = utils.flat_path(os.path.join(root_path, UpdateBuilder.HALL_MANIFEST_PATH))
        manifest_no_ext, ext = os.path.splitext(manifest_path)
        if os.path.isfile(manifest_path) or os.path.isfile(manifest_no_ext):
            # 文件已经存在了，不需要写
            return

        content = UpdateBuilder.HALL_MANIFEST_CONTENT_FMT % ','.join(hall_vers)
        f = open(manifest_path, 'w')
        f.write(content)
        f.close()

    def _create_temp_dir(self, folder_name):
        dir_path = utils.flat_path(os.path.join(os.path.dirname(self.proj_cfg), "%s/%s" % (UpdateBuilder.TEMP_DIR_NAME, folder_name)))
        if os.path.isdir(dir_path):
            shutil.rmtree(dir_path)
        return dir_path

    def _get_node_attr(self, node, attr_name):
        ret = node.getAttribute(attr_name)
        return utils.non_unicode_str(ret)

    def _get_file_hash(self, file_path):
        basename, ext = os.path.splitext(file_path)
        if ext == '.lua' or ext == '.plist' or ext == '.fsh' or ext == '.vsh':
            # shaders, lua 和 plist 文件使用 rU 方式读取，保证不受换行符影响
            f = open(file_path, 'rU')
        else:
            # 其他文件使用 rb 方式读取
            f = open(file_path, 'rb')

        content = f.read()
        f.close()
        return hashlib.sha1(content).hexdigest().upper()

    def _get_cur_files_info(self):
        # 返回数据格式如下：
        # {
        #      "path/to/file" : {
        #          "hash": sha1 hash value,
        #          "size": file size
        #      },
        #      ...
        # }
        cur_files_info = {}
        for (parent, dirs, files) in os.walk(self.src_path):
            for f in files:
                if f == '.DS_Store' or f == '.git':
                    continue

                full_path = os.path.join(parent, f)
                if self.exclude_cfg and utils.is_in_rule(full_path, self.src_path, self.exclude_cfg):
                    # 文件被排除了
                    Logging.debug_msg('%s 文件被排除了，不参与版本比较。' % full_path)
                    continue

                rel_path = os.path.relpath(full_path, self.src_path)

                hash = self._get_file_hash(full_path)
                size = os.path.getsize(full_path)
                cur_files_info[rel_path] = {
                    UpdateBuilder.XML_HASH_ATTR: hash,
                    UpdateBuilder.XML_SIZE_ATTR: size
                }

        return cur_files_info

    def save_ufd(self):
        new_content = self.doc_node.toprettyxml(encoding='utf8')
        # new_content 可能会出现空行，这里进行处理，删除空行
        lines = new_content.split('\n')
        new_lines = []
        for line in lines:
            if line.strip() != '':
                new_lines.append(line)

        f = open(self.proj_cfg, 'w')
        f.write('\n'.join(new_lines))
        f.close()

    def _get_node_by_path(self, check_path):
        nodes = self.root_node.getElementsByTagName(UpdateBuilder.XML_FILE_NODE_NAME)
        check_path = check_path.replace('\\', '/')
        for node in nodes:
            rel_path = self._get_node_attr(node, UpdateBuilder.XML_NAME_ATTR)
            full_path = utils.flat_path(os.path.join(self.src_path, rel_path))
            full_path = full_path.replace('\\', '/')
            if full_path == check_path:
                return node

        return None

    def _get_node_by_op(self, check_op, name):
        nodes = self.root_node.getElementsByTagName(UpdateBuilder.XML_FILE_NODE_NAME)
        for node in nodes:
            node_op = int(self._get_node_attr(node, UpdateBuilder.XML_OP_ATTR))
            if node_op != check_op:
                continue

            node_name = self._get_node_attr(node, UpdateBuilder.XML_NAME_ATTR)
            if node_name == name:
                return node

        return None

    # 将文件差异信息更新到 self.root_node 中
    def scan_files(self):
        Logging.debug_msg("---- 开始扫描文件改动 ----")

        cur_files_info = self._get_cur_files_info()
        nodes = self.root_node.getElementsByTagName(UpdateBuilder.XML_FILE_NODE_NAME)
        for node in nodes:
            name = self._get_node_attr(node, UpdateBuilder.XML_NAME_ATTR)
            op = int(self._get_node_attr(node, UpdateBuilder.XML_OP_ATTR))
            if op == UpdateBuilder.OP_ADD:
                full_path = utils.flat_path(os.path.join(self.src_path, name))
                if not os.path.isfile(full_path):
                    Logging.debug_msg('文件 %s 被删除' % full_path)
                    node.setAttribute(UpdateBuilder.XML_OP_ATTR, '%d' % UpdateBuilder.OP_DEL)
                    node.setAttribute(UpdateBuilder.XML_VERSION_ATTR, '%d' % self.cur_version)

        # 遍历文件
        for key in cur_files_info:
            file_info = cur_files_info[key]
            full_path = utils.flat_path(os.path.join(self.src_path, key))
            the_node = self._get_node_by_path(full_path)
            hash = file_info[UpdateBuilder.XML_HASH_ATTR]
            size = file_info[UpdateBuilder.XML_SIZE_ATTR]
            if the_node is None:
                Logging.debug_msg("新增文件 %s" % full_path)
                the_node = self.doc_node.createElement(UpdateBuilder.XML_FILE_NODE_NAME)
                relative_path = os.path.relpath(full_path, self.src_path)
                relative_path = relative_path.replace('\\', '/')
                the_node.setAttribute(UpdateBuilder.XML_NAME_ATTR, './' + relative_path)
                the_node.setAttribute(UpdateBuilder.XML_OP_ATTR, '%d' % UpdateBuilder.OP_ADD)
                the_node.setAttribute(UpdateBuilder.XML_HASH_ATTR, hash)
                the_node.setAttribute(UpdateBuilder.XML_SIZE_ATTR, '%d' % size)
                the_node.setAttribute(UpdateBuilder.XML_VERSION_ATTR, '%d' % self.cur_version)
                self.root_node.appendChild(the_node)
            else:
                xml_hash = self._get_node_attr(the_node, UpdateBuilder.XML_HASH_ATTR)
                old_op = int(self._get_node_attr(the_node, UpdateBuilder.XML_OP_ATTR))
                # 将 ufd 文件中的 name 里面的 \\ 转为 /
                old_name = self._get_node_attr(the_node, UpdateBuilder.XML_NAME_ATTR)
                the_node.setAttribute(UpdateBuilder.XML_NAME_ATTR, old_name.replace('\\', '/'))
                changed = False
                if old_op == UpdateBuilder.OP_DEL:
                    Logging.debug_msg("新增文件 %s" % full_path)
                    changed = True
                elif xml_hash.lower() != hash.lower():
                    Logging.debug_msg("文件 %s 被修改" % full_path)
                    changed = True

                if changed:
                    the_node.setAttribute(UpdateBuilder.XML_HASH_ATTR, hash)
                    the_node.setAttribute(UpdateBuilder.XML_SIZE_ATTR, '%d' % size)
                    the_node.setAttribute(UpdateBuilder.XML_OP_ATTR, '%d' % UpdateBuilder.OP_ADD)
                    the_node.setAttribute(UpdateBuilder.XML_VERSION_ATTR, '%d' % self.cur_version)

        # 如果版本扩展配置文件，需要增加相应的处理
        if self.ver_ext_cfg:
            ver_key = "%d" % self.cur_version
            if self.ver_ext_cfg.has_key(ver_key):
                cfg_v = self.ver_ext_cfg[ver_key]
                if cfg_v.has_key('do_file'):
                    cfg_do_file = cfg_v["do_file"]
                    dofile = "%s/%s" % (cfg_do_file["dstpath"], cfg_do_file["srcfile"])
                    the_node = self._get_node_by_op(UpdateBuilder.OP_RUN, dofile)
                    if the_node is None:
                        the_node = self.doc_node.createElement(UpdateBuilder.XML_FILE_NODE_NAME)
                    the_node.setAttribute(UpdateBuilder.XML_NAME_ATTR, dofile)
                    the_node.setAttribute(UpdateBuilder.XML_OP_ATTR, '%d' % UpdateBuilder.OP_RUN)
                    the_node.setAttribute(UpdateBuilder.XML_VERSION_ATTR, '%d' % self.cur_version)
                    self.root_node.appendChild(the_node)

                if cfg_v.has_key('del_files'):
                    cfg_del_files = cfg_v['del_files']
                    for v in cfg_del_files:
                        the_node = self._get_node_by_op(UpdateBuilder.OP_DEL, v)
                        if the_node is None:
                            the_node = self.doc_node.createElement(UpdateBuilder.XML_FILE_NODE_NAME)
                        the_node.setAttribute(UpdateBuilder.XML_NAME_ATTR, v)
                        the_node.setAttribute(UpdateBuilder.XML_OP_ATTR, '%d' % UpdateBuilder.OP_DEL)
                        the_node.setAttribute(UpdateBuilder.XML_VERSION_ATTR, '%d' % self.cur_version)
                        self.root_node.appendChild(the_node)

        Logging.debug_msg("---- 扫描文件改动结束 ----\n")

    def _do_encrypt(self, src_folder, dst_folder):
        sys.path.append(os.path.normpath(os.path.join(os.path.dirname(__file__), '../ResEncrypt')))
        from ResEncrypt import ResEncrypt
        encryptor = ResEncrypt(src_folder, dst_folder, True, UpdateBuilder.ASSETS_ENCRYPT_EXCLUDE_CFG, True)
        encryptor.do_encrypt()

    def _gen_zip_file(self, src_folder, dst_folder):
        # if self.no_encrypt:
        #     # 不对资源文件进行加密
        #     zip_path = src_folder
        # else:
        #     # 需要对资源文件进行加密
        #     zip_path = src_folder + '_output'
        #     self._do_encrypt(src_folder, zip_path)
        zip_path = src_folder

        # 压缩文件夹
        temp_dir = self._create_temp_dir('temp_zip_files')
        zip_file_path = os.path.join(temp_dir, 'temp.zip')
        if os.path.isfile(zip_file_path):
            os.remove(zip_file_path)

        utils.zip_folder(zip_path, zip_file_path)

        # 获取压缩文件的 hash 值
        hash = self._get_file_hash(zip_file_path)
        size = os.path.getsize(zip_file_path)

        # 将压缩文件拷贝到输出路径
        if not os.path.isdir(dst_folder):
            os.makedirs(dst_folder)
        out_file_name = '%s.cuf' % hash
        shutil.copy(zip_file_path, os.path.join(dst_folder, out_file_name))

        try:
            # 删除临时文件与目录
            shutil.rmtree(temp_dir)
            if zip_path != src_folder:
                shutil.rmtree(zip_path)
        except:
            pass

        return (out_file_name, size)

    def _gen_add_zip_str(self, file_name, size, version):
        return ',\n\t{op=0,version=%d,fname="%s",path="_tmp_.tmp",size=%d,compr=1}' % (version, file_name, size)

    def _get_op_path(self, path):
        ret = path
        if not self.no_encrypt:
            # 加密包中，操作的 lua 文件需要修改为 wld 文件
            if ret.endswith('.lua'):
                ret = ret.rstrip('lua') + 'wld'

        # op 中的 path 必须使用 /
        ret = ret.replace('\\', '/')
        return ret

    def gen_update_files(self):
        # 更新文件存放的临时位置
        output_temp_dir = self._create_temp_dir('temp_output_dir')
        cuf_files_path = os.path.join(output_temp_dir, self.out_name)

        # 生成更新包文件
        if self.lua_param:
            lua_param_str = ',%s' % self.lua_param
        else:
            lua_param_str = ''

        nodes = self.root_node.getElementsByTagName(UpdateBuilder.XML_FILE_NODE_NAME)

        # 排序函数，保证删除文件操作先完成
        def sort_func(x):
            op_value = int(self._get_node_attr(x, UpdateBuilder.XML_OP_ATTR))
            if op_value == UpdateBuilder.OP_DEL:
                op_value = -1

            return op_value

        nodes.sort(key=sort_func)
        tmp_dir = self._create_temp_dir('temp_version_files')

        # 加密work-dirs临时文件夹资源
        if not self.no_encrypt:
            self._do_encrypt(self.src_path, self.src_path)


        for i in range(UpdateBuilder.FULL_PKG_VERSION, self.cur_version):
            # 检测是否需要输出该版本（ FULL_PKG_VERSION 版本必须输出）
            if i != UpdateBuilder.FULL_PKG_VERSION and i < self.min_ver:
                continue

            Logging.debug_msg('---- 开始输出 %d 到 %d 版本的更新文件 ----' % (i, self.cur_version))

            # 生成 .lua 文件
            lua_file_path = os.path.join(output_temp_dir, '%s_%d.lua' % (self.out_name, i))
            lua_lines = [
                'return { version=%d%s' % (self.cur_version, lua_param_str)
            ]

            # add files info
            tmp_path = os.path.join(tmp_dir, 'ver_%d' % i)
            has_unzipped = False
            for node in nodes:
                node_ver = int(self._get_node_attr(node, UpdateBuilder.XML_VERSION_ATTR))

                if node_ver == UpdateBuilder.FULL_PKG_VERSION and self._is_handle_hall():
                    # 大厅的热更新包中不需要包含 0 号版本的文件
                    continue

                if i != UpdateBuilder.FULL_PKG_VERSION and node_ver <= i:
                    continue

                op = int(self._get_node_attr(node, UpdateBuilder.XML_OP_ATTR))
                if op == UpdateBuilder.OP_ADD:
                    # 新增文件，拷贝到临时文件夹
                    rel_path = self._get_node_attr(node, UpdateBuilder.XML_NAME_ATTR)
                    if not self.no_encrypt:
                        rel_path = rel_path.replace('.lua', '.wld')
                        if os.path.basename(rel_path) == 'manifest':
                            # manifest 文件加密后会变为 manifest.wld
                            rel_path = '%s.wld' % rel_path

                    src_file = utils.flat_path(os.path.join(self.src_path, rel_path))
                    dst_file = utils.flat_path(os.path.join(tmp_path, rel_path))
                    if not os.path.isdir(os.path.dirname(dst_file)):
                        os.makedirs(os.path.dirname(dst_file))
                    Logging.debug_msg('新增更新文件 %s' % rel_path)
                    shutil.copy(src_file, dst_file)
                    has_unzipped = True
                else:
                    if has_unzipped:
                        has_unzipped = False
                        zip_file_name, zip_size = self._gen_zip_file(tmp_path, cuf_files_path)
                        lua_lines.append(self._gen_add_zip_str(zip_file_name, zip_size, i))
                        shutil.rmtree(tmp_path)

                    op_str = ''
                    if op == UpdateBuilder.OP_DEL:
                        path = self._get_node_attr(node, UpdateBuilder.XML_NAME_ATTR)
                        path = self._get_op_path(path)
                        op_str = ',path="%s"' % path
                        Logging.debug_msg('删除文件 %s' % path)
                    elif op == UpdateBuilder.OP_REN:
                        src = self._get_node_attr(node, 'src')
                        src = self._get_op_path(src)
                        des = self._get_node_attr(node, 'des')
                        des = self._get_op_path(des)
                        op_str = ',src="%s",des="%s"' % (src, des)
                    elif op == UpdateBuilder.OP_RUN:
                        path = self._get_node_attr(node, UpdateBuilder.XML_NAME_ATTR)
                        op_str = ',path="%s"' % path
                        Logging.debug_msg('更新后执行文件 %s' % path)

                    lua_lines.append(',\n\t{op=%d,version=%s%s}' % (op, self._get_node_attr(node, UpdateBuilder.XML_VERSION_ATTR), op_str))

            if has_unzipped:
                has_unzipped = False
                zip_file_name, zip_size = self._gen_zip_file(tmp_path, cuf_files_path)
                lua_lines.append(self._gen_add_zip_str(zip_file_name, zip_size, i))
                shutil.rmtree(tmp_path)

            # lua 文件结束
            lua_lines.append('\n}')

            # 写入 lua 文件
            f = open(lua_file_path, 'w')
            f.writelines(lua_lines)
            f.close()

            Logging.debug_msg('---- %d 到 %d 版本的更新文件输出结束 ----' % (i, self.cur_version))

        # 获取输出目录
        cur_time_str = datetime.datetime.fromtimestamp(time.time()).strftime('%Y%m%d_%H%M%S')
        proj_file_name = os.path.basename(self.proj_cfg)
        proj_name, ext = os.path.splitext(proj_file_name)
        out_name = '%s_%s_%s.zip' % (proj_name, self.out_name, cur_time_str)
        output_path = os.path.join(os.path.dirname(self.proj_cfg), UpdateBuilder.OUTPUT_DIR_NAME, out_name)

        # 将更新文件进行压缩
        utils.zip_folder(output_temp_dir, output_path)
        Logging.debug_msg('\n更新文件已生成，保存路径：%s' % output_path)

        # 删除临时目录
        try:
            shutil.rmtree(tmp_dir)
            shutil.rmtree(output_temp_dir)
        except:
            pass

    def do_build(self):
        if self.src_path is None:
            raise_known_error("未指定工作路径", KnownError.ERROR_WRONG_ARGS)

        if not os.path.isdir(self.src_path):
            raise_known_error("%s 文件夹不存在" % self.src_path, KnownError.ERROR_PATH_NOT_FOUND)

        Logging.debug_msg('工作目录：%s' % self.src_path)
        Logging.debug_msg('当前版本：%d' % self.cur_version)
        Logging.debug_msg('')

        # 检测文件改动
        self.scan_files()

        if not self.no_pack:
            # 生成更新文件
            self.gen_update_files()

        # 保存 ufd 文件
        if self.do_save:
            # 更新版本号
            self.root_node.setAttribute(UpdateBuilder.XML_VERSION_ATTR, '%d' % self.cur_version)
            self.save_ufd()

        # 删除临时的 src 路径
        try:
            shutil.rmtree(self.src_path)
            temp_path = utils.flat_path(os.path.join(os.path.dirname(self.proj_cfg), UpdateBuilder.TEMP_DIR_NAME))
            shutil.rmtree(temp_path)
        except:
            pass

if __name__ == "__main__":
    from argparse import ArgumentParser
    parser = ArgumentParser(prog="UpdateBuilder", description=utils.get_sys_encode_str("热更新包生成工具"))

    parser.add_argument("-p", "--proj-cfg", dest="proj_cfg", required=True, help=utils.get_sys_encode_str("指定 .ufd 格式的工程文件路径。"))
    parser.add_argument("-s", "--src", dest="src", required=True, action="append", help=utils.get_sys_encode_str("指定工作目录。"))
    parser.add_argument("--lua-param", dest="lua_param", help=utils.get_sys_encode_str("指定附带参数。"))
    parser.add_argument("--cur-ver", dest="cur_ver", help=utils.get_sys_encode_str("指定当前版本号。"))
    parser.add_argument("--min-ver", dest="min_ver", help=utils.get_sys_encode_str("指定最低输出版本。默认值为 1。"))
    parser.add_argument("--out-name", dest="out_name", help=utils.get_sys_encode_str("指定输出的 lua 更新文件名称。"))
    parser.add_argument("--no-pack", dest="no_pack", action='store_true', help=utils.get_sys_encode_str("使用此参数，则本次操作不生成更新包文件。"))
    parser.add_argument("--save", dest="do_save", action='store_true', help=utils.get_sys_encode_str("更新包生成之后更新 .ufd 文件内容。"))
    parser.add_argument("--no-encrypt", dest="no_encrypt", action='store_true', help=utils.get_sys_encode_str("若指定此参数，则不对资源文件进行加密。"))
    parser.add_argument("--encrypt-exclude", dest="encrypt_exclude_cfg", help=utils.get_sys_encode_str("指定资源文件加密过程中需要排除的规则文件。"))
    parser.add_argument("-b", dest='brand', choices=utils.get_support_brands(), default='weile', help=utils.get_sys_encode_str("指定当前打包的品牌，可选值为 weile，jixiang。默认为 weile"))
    parser.add_argument("--exclude", dest="exclude_cfg", help=utils.get_sys_encode_str("指定检查版本更新时需要忽略的文件或者文件夹。"))
    parser.add_argument("--region", dest="region", help=utils.get_sys_encode_str("指定包地区码，控制热更包打入的地图资源。"))
    parser.add_argument("--ver-ext-cfg", dest="ver_ext_cfg", help=utils.get_sys_encode_str("指定版本扩展配置文件。"))

    (args, unknown) = parser.parse_known_args()

    # record the start time
    begin_time = time.time()
    try:
        if len(unknown) > 0:
            raise_known_error('未知参数 : %s' % unknown, KnownError.ERROR_WRONG_ARGS)

        builder = UpdateBuilder(args)
        builder.do_build()
    except KnownError as e:
        # a known exception, exit with the known error number
        sys.exit(e.get_error_no())
    except Exception:
        raise
    finally:
        # output the spend time
        end_time = time.time()
        Logging.log_msg('\n总共用时： %.2f 秒\n' % (end_time - begin_time))

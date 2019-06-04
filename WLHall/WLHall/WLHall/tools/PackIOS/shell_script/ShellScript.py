# -*- coding: UTF-8 -*-
#!/usr/bin/python
#coding:utf-8
import os
import sys
import hashlib
import shutil

###### 描述：这个文件主要用于编译完成后对.app内容进行删除、加密等操作

default_encoding = 'utf-8'
if sys.getdefaultencoding() != default_encoding:
    reload(sys)
    sys.setdefaultencoding(default_encoding)

sys.path.append(os.path.dirname(os.path.dirname(__file__)))
from python_libs.Common import Common
from python_libs.FileUtils import FileUtils
from python_libs.JsonObj import JsonObj

sys.path.append(os.path.normpath(os.path.join(os.path.dirname(__file__), '../../utils')))
import utils

m_appPath = None
m_jsonObj = None

kCfgFiles = "cfg_files"
kResFiles = "res_files"
kGames    = "games"
kPkgName  = "pkg_name"
kEncryptScript = "encrypt_script"
# kAddH5Pay = "add_h5_pay"
kRegion   = "region"

# 读取配置表
def loadConfig():
    global m_appPath
    global m_jsonObj

    Common.assertExit(len(sys.argv[1:])!=0, "请传入配置文件绝对路径")
    Common.assertExit(os.path.isdir(sys.argv[1]), "传入参数文件夹不存在")
    m_appPath = sys.argv[1]

    configPath = FileUtils.getAbsolutePath("config.json")
    m_jsonObj = JsonObj()
    m_jsonObj.loadFromFilePath(configPath)

    Common.assertExit(Common.isArrayType(m_jsonObj[kGames]), "必须设置参数games")
    Common.assertExit(m_jsonObj[kCfgFiles], "必须设置参数cfg_files")
    Common.assertExit(m_jsonObj[kPkgName], "必须设置参数pkg_name")
    Common.assertExit(m_jsonObj[kRegion], "必须设置参数region")

def getAbspathForKey(key):
    value = m_jsonObj[key]
    if not value or len(value)==0:
        return None
    if os.path.isabs(value):
        return value
    return FileUtils.getAbsolutePath(value)

# 拷贝配置文件
def copyConfigFiles():
    sourcePath = getAbspathForKey(kCfgFiles)
    if None==sourcePath:
        return

    srcPath = os.path.join(m_appPath, "src")
    FileUtils.copyDirctory(sourcePath, srcPath)

# 拷贝 res 文件夹
def copyResFiles():
    sourcePath = getAbspathForKey(kResFiles)
    if None == sourcePath:
        return

    resPath = os.path.join(m_appPath, "res")
    FileUtils.copyDirctory(sourcePath, resPath)

# 删除games目录下不需要的资源
def deleteGamesDir():
    gamesDir = os.path.join(m_appPath, "games")
    if not os.path.isdir(gamesDir):
        return

    gamesDirConfig = m_jsonObj[kGames]
    _, names = FileUtils.getDirectorysFromDirectory(gamesDir)
    for name in names:
        if not (name in gamesDirConfig):
            deletePath = os.path.join(gamesDir, name)
            FileUtils.removeDirectory(deletePath)

# 删除games目录下不需要的资源
def deleteMapDir():
    region = m_jsonObj[kRegion]
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

    map_path = utils.flat_path(os.path.join(m_appPath, 'res/hall/map'))
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

# 删除调试相关的资源
def deleteDebugFiles():
    debugFile = os.path.join(m_appPath, 'src/LuaDebugjit.lua')
    if os.path.isfile(debugFile):
        os.remove(debugFile)

def resEncryptByDirName(dirName):
    encryptScript = os.path.normpath(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../ResEncrypt/ResEncrypt.py')))
    if None==encryptScript:
        return

    targetDir = os.path.join(m_appPath, dirName)
    Common.assertExit(os.path.isdir(targetDir), "配置games文件不存在：" + dirName)

    ASSETS_ENCRYPT_EXCLUDE_CFG = [
        "mj_common/images/card_packer/*.png"
    ]

    sys.path.append(os.path.dirname(encryptScript))
    from ResEncrypt import ResEncrypt
    encryptor = ResEncrypt(targetDir, targetDir, True, ASSETS_ENCRYPT_EXCLUDE_CFG, False)
    encryptor.do_encrypt()

# 加密脚本和资源
def resEncrypt():
    resEncryptByDirName("games")
    resEncryptByDirName("res")
    resEncryptByDirName("src")

def getHashPath(srcStr):
    basename, ext = os.path.splitext(srcStr)
    paths = basename.split('/')
    new_paths = []
    for p in paths:
        useStr = '%s%s' % (m_jsonObj[kPkgName], p)
        md5Hash = hashlib.md5(useStr)
        md5Hashed = md5Hash.hexdigest()
        new_paths.append(md5Hashed)

    return '%s%s' % ('/'.join(new_paths), ext)

def obscureResPaths():
    obscurePaths = [
        "games", "src", "res"
    ]
    for p in obscurePaths:
        srcPath = os.path.join(m_appPath, p)
        for parent, dirs, files in os.walk(srcPath):
            for f in files:
                full_path = os.path.join(parent, f)
                rel_path = os.path.relpath(full_path, m_appPath)
                target_path = os.path.join(m_appPath, getHashPath(rel_path))
                target_dir = os.path.dirname(target_path)
                if not os.path.isdir(target_dir):
                    os.makedirs(target_dir)
                shutil.copy2(full_path, target_path)

        # 移除原始文件
        shutil.rmtree(srcPath)

if __name__ == "__main__":
    Common.assertExit(len(sys.argv[2:])!=0, "第二个参数不能为空，必须是${CONFIGURATION}")

    # Debug版本不处理
    appPath = sys.argv[1]
    srcPath = os.path.join(appPath, "src")

    # 读取配置表
    loadConfig()

    # 生成 native 环境信息文件
    utils.write_native_info(os.path.join(srcPath, 'NativeInfo.lua'), {"no_agora": "true", "ios_no_h5": "true"})

    if sys.argv[2]=="Debug":
        if os.path.isdir(srcPath):
            f = open(os.path.join(srcPath, 'myflag'), 'w')
            f.write('')
            f.close()
        exit(0)

    # 拷贝配置文件
    copyConfigFiles()

    # 拷贝 res 文件
    copyResFiles()

    # 删除games目录下不需要的资源
    deleteGamesDir()

    # 删除res/hall/map目录下不需要的资源
    deleteMapDir()

    # 删除 debug 资源
    deleteDebugFiles()

    # 加密脚本和资源
    resEncrypt()

    # 混淆文件路径
    obscureResPaths()

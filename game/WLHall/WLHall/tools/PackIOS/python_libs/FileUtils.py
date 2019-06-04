#!/usr/bin/python
#coding:utf-8
import os
import sys
import types
import shutil

from Common import Common
from Array import Array

class FileUtils:
    # 桌面路径
    @staticmethod
    def getDesktopPath():
        return os.path.join(os.path.expanduser("~"), 'Desktop')

    # 获得入口脚本的文件夹路径
    @staticmethod
    def getScriptDirectory():
        path = os.path.abspath(sys.argv[0])
        path = os.path.realpath(path)
        path = os.path.dirname(path)
        return path

    # 根据absolutePath和relativePath，获得绝对路径
    @staticmethod
    def getAbsoluteFromPath(absolutePath, relativePath):
        Common.assertExit(os.path.isabs(absolutePath), "请传入绝对路径：" + absolutePath)
        Common.assertExit(not os.path.isabs(relativePath), "请传入相对路径：" + relativePath)
        path = os.path.join(absolutePath, relativePath)
        path = os.path.abspath(path)
        return path

    # 根据当前运行脚本路径，获得绝对路径
    @staticmethod
    def getAbsolutePath(relativePath):
        scriptPath = FileUtils.getScriptDirectory()
        return FileUtils.getAbsoluteFromPath(scriptPath, relativePath)

    # 获得文件的文件夹路径，如/usr/dir/xxx.txt -> /usr/dir/
    @staticmethod
    def getFileDirectory(filePath):
        return os.path.dirname(filePath)

    # 获得文件名，如/usr/dir/xxx.txt -> xxx.txt
    @staticmethod
    def getFileName(filePath):
        return os.path.basename(filePath)

    # 获得文件前缀名，如/usr/dir/xxx.txt -> xxx
    @staticmethod
    def getFilePrefixFromFilePath(filePath):
        fileName = FileUtils.getFileName(filePath)
        return FileUtils.getFilePrefix(fileName)

    # 获得文件前缀名，如"xxx.txt" -> xxx
    @staticmethod
    def getFilePrefix(fileName):
        prefix, _ = os.path.splitext(fileName)
        return prefix

    # 获得文件后缀名，如"xxx.txt" -> .txt
    @staticmethod
    def getFileSuffix(fileName):
        _, suffix = os.path.splitext(fileName)
        return suffix

    # 获得文件大小，单位为字节
    @staticmethod
    def getFileSize(filePath):
        Common.assertExit(os.path.isfile(filePath), "文件不存在：" + filePath)
        return os.path.getsize(filePath)

    # 获得文件夹下的所有文件集合，返回第一值是绝对路径，第二个值只是文件名集合
    @staticmethod
    def getFilePathsFromDirectory(dirPath):
        Common.assertExit(os.path.isdir(dirPath), "文件夹不存在：" + dirPath)
        filePaths = []
        fileNames = []
        for fileName in os.listdir(dirPath):
            path = os.path.join(dirPath, fileName)
            if os.path.isfile(path):
                Array.insert(filePaths, path)
                Array.insert(fileNames, fileName)
        return filePaths, fileNames

    # 获得文件夹下的所有文件夹集合，返回第一值是绝对路径，第二个值只是文件名集合
    @staticmethod
    def getDirectorysFromDirectory(dirPath):
        Common.assertExit(os.path.isdir(dirPath), "文件夹不存在：" + dirPath)
        dirPaths = []
        dirNames = []
        for fileName in os.listdir(dirPath):
            path = os.path.join(dirPath, fileName)
            if os.path.isdir(path):
                Array.insert(dirPaths, path)
                Array.insert(dirNames, fileName)
        return dirPaths, dirNames

    # 创建文件夹，包含多层级文件夹
    @staticmethod
    def createDirectory(dirPath):
        if not os.path.isdir(dirPath):
            os.makedirs(dirPath)

    # 删除文件夹，包含多层级文件夹
    @staticmethod
    def removeDirectory(dirPath):
        if os.path.isdir(dirPath):
            shutil.rmtree(dirPath)

    # 删除文件
    @staticmethod
    def removeFile(filePath):
        if os.path.isfile(filePath):
            os.remove(filePath)

    # 拷贝sourceFile文件到targetFile
    @staticmethod
    def copyFile(sourceFile, targetFile):
        Common.assertExit(os.path.isfile(sourceFile), "源文件不存在" + sourceFile)

        # 创建目标文件夹
        targetDir = FileUtils.getFileDirectory(targetFile)
        FileUtils.createDirectory(targetDir)
        shutil.copy(sourceFile, targetFile)

    # 将sourceDir目录下的文件和文件夹拷贝到targetDir目录，递归拷贝
    @staticmethod
    def copyDirctory(sourceDir, targetDir):
        Common.assertExit(os.path.isdir(sourceDir), "源文件夹不存在" + sourceDir)
    
        # 创建目标文件夹
        FileUtils.createDirectory(targetDir)

        # 拷贝文件
        _, fileNames = FileUtils.getFilePathsFromDirectory(sourceDir)
        for fileName in fileNames:
            sourceFile = os.path.join(sourceDir, fileName)
            targetFile = os.path.join(targetDir, fileName)
            FileUtils.copyFile(sourceFile, targetFile)

        # 递归拷贝文件夹
        _, dirNames = FileUtils.getDirectorysFromDirectory(sourceDir)
        for dirName in dirNames:
            newSourceDir = os.path.join(sourceDir, dirName)
            newTargetDir = os.path.join(targetDir, dirName)
            FileUtils.copyDirctory(newSourceDir, newTargetDir)

    # 文件夹替换拷贝，删除目标文件夹
    @staticmethod
    def replaceCopyDirctory(sourceDir, targetDir):
        FileUtils.removeDirectory(targetDir)
        FileUtils.copyDirctory(sourceDir, targetDir)

    # 递归遍历文件夹下的所有文件
    @staticmethod
    def getFilePathsFromDirectory2(path):
        allFile = []
        FileUtils._getFilePathsFromDirectory2(path, allFile)
        return allFile  

###########################################################

    @staticmethod
    def _getFilePathsFromDirectory2(path, allFile):
        filelist =  os.listdir(path)  
        for filename in filelist:  
            filepath = os.path.join(path, filename)  
            if os.path.isdir(filepath):  
                FileUtils._getFilePathsFromDirectory2(filepath, allFile)  
            else:
                allFile.append(filepath)

# if __name__ == "__main__":
#     path = FileUtils.getFilePathsFromDirectory2("/Users/weile/Desktop/MJCore")
#     for p in path:
#         print(p)

    # FileUtils.copyFile("/Users/weile/Desktop/python_libs/FileUtils.py", "/Users/weile/Desktop/build/11.py")

    # FileUtils.copyDirctory("/Users/weile/Desktop/build/33", "/Users/weile/Desktop/build/44")

   




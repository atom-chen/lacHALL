#!/usr/bin/python
#coding:utf-8
import os
import sys

from Common import Common

# 对Plist文件读取和修改
class Plist:
    @staticmethod
    def isKeyExist(plistPath, key):
        value = Plist.getForKey(plistPath, key)
        return value!=""

    # key = CFBundleURLTypes:2:CFBundleURLName 表示获取CFBundleURLTypes下第2个数组(从0开始索引)的CFBundleURLName值
    @staticmethod
    def getForKey(plistPath, key):
        Common.assertExit(os.path.isfile(plistPath), plistPath + "文件不存在")

        cmd = "/usr/libexec/PlistBuddy -c 'Print %s' %s" % (key, plistPath)
        return Common.getCmdResult(cmd)

    @staticmethod
    def setForKey(plistPath, key, value):
        Common.assertExit(os.path.isfile(plistPath), plistPath + "文件不存在")

        if Plist.isKeyExist(plistPath, key):
            cmd = '/usr/libexec/PlistBuddy -c "Set :%s %s" %s' % (key, value, plistPath)
            return Common.runCmd(cmd)
        Plist.addStringForKey(plistPath, key, value)

    # 重置key的数组值
    @staticmethod
    def resetArrayForKey(plistPath, key, valueArr):
        Plist.deleteForKey(plistPath, key)
        Plist.addArrayForKey(plistPath, key, valueArr)

    @staticmethod
    def addStringForKey(plistPath, key, value):
        Common.assertExit(os.path.isfile(plistPath), plistPath + "文件不存在")

        cmd = '/usr/libexec/PlistBuddy -c "Add :%s string %s" %s' % (key, value, plistPath)
        return Common.runCmd(cmd)

    @staticmethod
    def addArrayForKey(plistPath, key, valueArr):
        Common.assertExit(os.path.isfile(plistPath), plistPath + "文件不存在")
        Common.assertArrayType(valueArr)

        cmd = '/usr/libexec/PlistBuddy -c "Add :%s array" %s' % (key, plistPath)
        Common.runCmd(cmd)

        index = 0
        for value in valueArr:
            subKey = "%s:%d" % (key, index)
            Plist.addStringForKey(plistPath, subKey, value)
            index = index + 1            

    @staticmethod
    def deleteForKey(plistPath, key):
        Common.assertExit(os.path.isfile(plistPath), plistPath + "文件不存在")
       
        cmd = '/usr/libexec/PlistBuddy -c "Delete :%s" %s' % (key, plistPath)
        Common.runCmd(cmd)

    

# if __name__ == "__main__":
    # value = Plist.addStringForKey("/Users/weile/Desktop/Info.plist", "CFBundleURLTypes:0:CFBundleURLSchemes:0", "add string")

    # Plist.resetArrayForKey("/Users/weile/Desktop/Info.plist", "CFBundleURLTypes:0:CFBundleURLSchemes2", ["1", "2", "3"])

   






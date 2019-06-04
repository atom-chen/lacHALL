#!/usr/bin/python
#coding:utf-8
import os
import sys

from Common import Common

# 替换文件内容
class Sed:
    # 替换filePath文件内所有内容是sourceContent改为targetContent
    @staticmethod
    def replaceContent(sourceContent, targetContent, filePath):
        Common.assertExit(os.path.isfile(filePath), "文件不存在")

        content = 's/%s/%s/g'%(sourceContent, targetContent)
        cmd = 'sed -i "" "%s" %s' % (content, filePath) 
        Common.runCmd(cmd)

    # 替换filePath文件内所有内包含sourceContent字符的行，整行替换为targetContent
    @staticmethod
    def replaceLine(sourceContent, targetContent, filePath):
        Common.assertExit(os.path.isfile(filePath), "文件不存在")

        content = 's/%s.*/%s/'%(sourceContent, targetContent)
        cmd = 'sed -i "" "%s" %s' % (content, filePath) 
        Common.runCmd(cmd)
        
# if __name__ == "__main__":
#     Sed.replaceLine("ProvisioningStyle =", "ProvisioningStyle = 4444;", "/Users/weile/Desktop/111/ss.txt")






#!/usr/bin/python
#coding:utf-8
import os
import sys
import types 
import getpass

class Common:
    # 执行命令
    @staticmethod
    def runCmd(cmd):
        res = os.system(cmd)
        Common.assertExit(res==0, "执行命名行错误：")

    # 获取当前系统用于名
    @staticmethod
    def getUserName():
        return getpass.getuser()

    # 正确提示
    @staticmethod
    def rightTips(text):
        print('\033[1;32;40m')
        print('*' * 50)
        print '正确提示：' + text
        print('*' * 50)
        print('\033[0m')

    # 错误提示信息
    @staticmethod
    def wrongTips(text):
        Common.wrongTipsWithText('错误提示：' + text)

    # 输入提示
    @staticmethod
    def inputTips(text):
        print('\033[1;33;40m')
        print('*' * 50)
        print text
        print('*' * 50)
        print('\033[0m')

    @staticmethod
    def wrongTipsWithText(text):
        print('\033[1;31;40m')
        print('*' * 50)
        print text
        print('*' * 50)
        print('\033[0m')

    # 是否是List(数组)数据类型
    @staticmethod
    def isArrayType(value):
        return type(value) == type([])

    # 是否字典类型
    @staticmethod
    def isDictionaryType(value):
        return type(value) == type({})

    # 是否是Bool数据类型
    @staticmethod
    def isBoolType(value):
        return type(value) == type(False)

    # 是否是字符串数据类型
    @staticmethod
    def isStringType(value):
        return type(value) == type("")

    # 是否是整形、浮点数数据类型
    @staticmethod
    def isNumberType(value):
        return type(value)==type(0) or type(value)==type(0.0)

    # 触发断言直接退出
    @staticmethod
    def assertExit(condition, errorMessage=""):
        if not condition:
            Common.wrongTipsWithText("断言报错：" + errorMessage)
            exit(0)

    # 是否是字典数据类型，否则触发断言
    @staticmethod
    def assertBoolType(value, errorMsg = "非Bool数据类型"):
        Common.assertExit(Common.isBoolType(value), errorMsg)

    # 是否是整数、浮点数数据类型，否则触发断言
    @staticmethod
    def assertNumberType(value):
        Common.assertExit(Common.isNumberType(value), "非Number数据类型")

    # 是否是List数据类型，否则触发断言
    @staticmethod
    def assertArrayType(value):
        Common.assertExit(Common.isArrayType(value), "非Array数据类型")

    # 是否是字典数据类型，否则触发断言
    @staticmethod
    def assertDictionaryType(value):
        Common.assertExit(Common.isDictionaryType(value), "非Dictionary数据类型")

    # 是否是字符串类型，否则触发断言
    @staticmethod
    def assertStringType(value):
        Common.assertExit(Common.isStringType(value), "非String数据类型")



    # 获取命令行输出结果
    @staticmethod
    def getCmdResult(cmd):
        r = os.popen(cmd)  
        text = r.read()  
        r.close()  
        return text.strip('\n')

# if __name__ == "__main__":
    # assertExit(True, "ddddd")
    # Common.wrongTips("333")
    # print(Common.isNumberType(1.1))
    # print ( type(2) is types.BoolType )





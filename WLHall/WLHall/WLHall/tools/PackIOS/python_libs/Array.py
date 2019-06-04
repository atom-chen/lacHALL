#!/usr/bin/python
#coding:utf-8
import os
import sys
import types 

from Common import Common

# 模仿Lua的接口
class Array:
    @staticmethod
    def insert(listData, value):
        Common.assertArrayType(listData)
        list.append(listData, value)

    # 通过索引删除节点，index从1开始
    @staticmethod
    def remove(listData, index):
        Common.assertArrayType(listData)
        Common.assertExit(index>0)
        index = index - 1
        del listData[index]
        
    # 通过值删除节点
    @staticmethod
    def removeByValue(listData, value):
        Common.assertArrayType(listData)
        if value in listData:
            listData.remove(value)

    # 替换值，index从1开始
    @staticmethod
    def replace(listData, index, value):
        Common.assertArrayType(listData)
        Common.assertExit(index>0)
        listData[index-1] = value

    # 值是否存在
    @staticmethod
    def isValueExist(listData, value):
        Common.assertArrayType(listData)
        return value in listData

# if __name__ == "__main__":
    # listData = { 1:"11", 2:"22" }
    # print Array.findValue(listData, 1)





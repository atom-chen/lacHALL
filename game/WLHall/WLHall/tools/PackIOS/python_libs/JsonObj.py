#!/usr/bin/python
#coding:utf-8
import os
import sys
import types 
import json

from Common import Common

# 模仿Lua的接口
class JsonObj:
    def __init__(self):
        self._jsonData = {}

    def loadFromFilePath(self, filePath):
        Common.assertExit(os.path.isfile(filePath), "文件不存在：" + filePath)
        with open(filePath) as jsonData:
            self._jsonData = json.load(jsonData)

    def safeLoadFromFilePath(self, filePath):
        if not os.path.isfile(filePath):
            return
        with open(filePath) as jsonData:
            self._jsonData = json.load(jsonData)
        
    def saveToFile(self, filePath):
        with open(filePath, 'w') as jsonFile:
            jsonFile.write(json.dumps(self._jsonData))

#######################################################

    def __setitem__(self, key, value):
        self._jsonData[key] = value

    def __getitem__(self, key):
        if self._jsonData.has_key(key):
            return self._jsonData[key]
        return None

# if __name__ == "__main__":
    # js = JsonObj()
    # js["2222"] = "dddd"
    # js.saveToFile("/Users/weile/Desktop/test2.json")
    # js.loadFromFilePath("/Users/weile/Desktop/test.json")
    # print js





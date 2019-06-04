#!/usr/bin/python
#coding:utf-8
import os
import sys
import types 

from Common import Common

class Dictionary:
    @staticmethod
    def setValueForKey(dicData, key, value):
        Common.assertDictionaryType(dicData)
        dicData[key] = value

    @staticmethod
    def getValueForKey(dicData, key):
        Common.assertDictionaryType(dicData)
        if dicData.has_key(key):
            return dicData[key]
        
    
    @staticmethod
    def removeValueForKey(dicData, key):
        Common.assertDictionaryType(dicData)
        if dicData.has_key(key):
            del dicData[key]
        
# if __name__ == "__main__":
    # dicData = { 1:"11", 2:"22" }
    # print Dictionary.getValueForKey(dicData, 3)
    # print Dictionary.getValueForKey(dicData, 4)





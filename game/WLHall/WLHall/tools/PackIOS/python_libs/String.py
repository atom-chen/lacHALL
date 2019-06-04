#!/usr/bin/python
#coding:utf-8
import os
import sys
import types 

from Common import Common
from Array import Array

# 模仿Lua的接口
class String:
    # 分割字符串，split("1, 2, 3", ",") -> [1, 2, 3]
    @staticmethod
    def split(str, split):
        return str.split(split)
    

if __name__ == "__main__":
    arr = String.split('ab,cde,fgh,ijk', ",")
    for value in arr:
        print(value)    
    





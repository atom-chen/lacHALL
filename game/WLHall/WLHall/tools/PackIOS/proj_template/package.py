# -*- coding: UTF-8 -*-  
#!/usr/bin/python
#coding:utf-8
import os
import sys

sys.path.append('../')
sys.path.append(os.path.dirname(os.path.dirname(__file__)))
from python_libs.FileUtils import FileUtils

if __name__ == "__main__":
    pythonDir = FileUtils.getAbsolutePath("..")
    pythonPath = os.path.join(pythonDir, "main.py")
    
    configDir = FileUtils.getScriptDirectory()
    configPath = os.path.join(configDir, "config.json")
    cmd = "python " + pythonPath + " " + configPath

    os.system(cmd)


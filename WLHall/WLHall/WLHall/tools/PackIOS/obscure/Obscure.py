# -*- coding: UTF-8 -*-
#!/usr/bin/python
#coding:utf-8

import os
import sys
import shutil
import uuid
import random
import re

sys.path.append(os.path.dirname(__file__))
from modify_pbxproj import XcodeProject

ADD_CODE_FILE_COUNT = 1
METHOD_COUNT = 1000

METHOD_TEMPLATES = [
    '''
// count 4
bool* $method_name(int* $var1, std::string* $var2)
{
    int $var3 = 0;
    do
    {
        int $var4 = 0;
        while($var4 < rand())
        {
            return NULL;
        }
    }
    while ($var3 < rand());

    $other_method(NULL, NULL);
    return NULL;
}
    ''',
    '''
// count 4
int* $method_name(bool* $var1, std::string* $var2)
{
    bool $var3 = false;
    if ($var3)
    {
        return NULL;
    }
    
    int $var4 = 0;
    while($var4 < rand())
    {
        return NULL;
    }

    $other_method(NULL, NULL);
    return NULL;
}
    ''',
    '''
// count 4
std::string* $method_name(int* $var1, bool* $var2)
{
    int $var3 = 0;
    do
    {
        int $var4 = 0;
        while($var4 < rand())
        {
            return NULL;
        }
    }
    while ($var3 < rand());
    
    $other_method(NULL, NULL);
    return NULL;
}
    '''
]

class Obscurer(object):
    def __init__(self, proj_file_path, target_name, file_recorder):
        self.pbxproj_file = proj_file_path
        self.target_name = target_name
        proj_path = os.path.dirname(os.path.dirname(self.pbxproj_file))
        self.add_files_path = os.path.join(proj_path, 'obscure')
        self.header_path = os.path.join(self.add_files_path, 'obscure.h')
        self.cpp_path = os.path.join(self.add_files_path, 'obscure.cpp')
        self.file_recorder = file_recorder

    def _gen_uuid(self):
        the_uuid = 'T%s' % str(uuid.uuid4()).upper()
        the_uuid = the_uuid.replace('-', '')
        return the_uuid

    def _gen_code_files(self):
        if not os.path.isfile(self.header_path):
            raise Exception("%s 不存在" % self.header_path)
        if not os.path.isfile(self.cpp_path):
            raise Exception("%s 不存在" % self.cpp_path)

        self.file_recorder.record_file(self.header_path)
        self.file_recorder.record_file(self.cpp_path)

        # generate method names
        method_names = []
        for i in range(METHOD_COUNT):
            method_name = self._gen_uuid()
            method_names.append(method_name)

        # collect the result lines
        header_lines = []
        cpp_lines = []
        for i in range(METHOD_COUNT):
            selfName = method_names[i]
            if i < (METHOD_COUNT - 1):
                otherName = method_names[i + 1]
            else:
                otherName = None

            header_line, method_line = self._gen_method_str(selfName, otherName)
            header_lines.append(header_line)
            cpp_lines.append(method_line)

        # write files
        self._write_header_file(header_lines)
        self._write_cpp_file(cpp_lines, method_names[0])

    def _write_header_file(self, lines):
        f = open(self.header_path)
        old_lines = f.readlines()
        f.close()

        new_lines = []
        for l in old_lines:
            new_lines.append(l)
            if l.find('add methods begin') > 0:
                new_lines.extend(lines)

        f = open(self.header_path, 'w')
        f.writelines(new_lines)
        f.close()

    def _write_cpp_file(self, lines, invoke_name):
        f = open(self.cpp_path)
        old_lines = f.readlines()
        f.close()

        new_lines = []
        for l in old_lines:
            if l.find('$entry_method') > 0:
                new_lines.append(l.replace('// $entry_method', invoke_name))
            else:
                new_lines.append(l)

            if l.find('add methods begin') > 0:
                new_lines.extend(lines)

        f = open(self.cpp_path, 'w')
        f.writelines(new_lines)
        f.close()

    def _gen_method_str(self, method_name, other_name):
        template_size = len(METHOD_TEMPLATES)
        rand_idx = random.randint(0, template_size) % template_size
        template = METHOD_TEMPLATES[rand_idx]

        template_lines = template.split('\n')
        new_template_lines = []
        pattern = r'^// count ([\d]+)'
        var_count = 0
        header_line = ''
        for l in template_lines:
            match = re.match(pattern, l)
            if match:
                var_count = int(match.group(1))
                new_template_lines.append(l)
            elif l.find('$method_name') >= 0:
                header_line = l
                new_template_lines.append(l)
            elif (l.find('$other_method') >= 0) and (other_name is None):
                pass
            else:
                new_template_lines.append(l)

        template = '\n'.join(new_template_lines)
        header_line = 'static %s;\n' % header_line.rstrip('\n')
        header_line = header_line.replace('$method_name', method_name)

        # generate variable string
        template = template.replace('$method_name', method_name)
        if other_name:
            template = template.replace('$other_method', other_name)
        for i in range(var_count):
            var_name = self._gen_uuid()
            template = template.replace('$var%d' % (i+1), var_name)
            header_line = header_line.replace('$var%d' % (i+1), var_name)

        return header_line, template

    def add_obscure_code(self):
        if not os.path.isfile(self.pbxproj_file):
            raise Exception("%s 不存在" % self.pbxproj_file)

        self._gen_code_files()

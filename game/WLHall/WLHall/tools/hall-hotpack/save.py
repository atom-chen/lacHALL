#!/usr/bin/python
#-*- coding: utf-8 -*-
import os
import subprocess

def run_shell(cmd, cwd=None, quiet=False):
    p = subprocess.Popen(cmd, shell=True, cwd=cwd)
    p.wait()

    if p.returncode:
        raise Exception('Command %s failed' % cmd)

def flat_path(p):
    return os.path.normpath(os.path.abspath(os.path.expanduser(p)))

PROJ_ROOT = flat_path(os.path.join(os.path.dirname(__file__), '../../../'))
HALL_ROOT = os.path.join(PROJ_ROOT, 'WLHall')
TOOLS_PATH = flat_path(os.path.join(HALL_ROOT, 'tools/UpdateBuilder/UpdateBuilder.py'))
CUR_PATH = flat_path(os.path.dirname(__file__))
EXCLUDE_FILE = flat_path(os.path.join(CUR_PATH, 'exclude.json'))
DO_FILES_CFG = flat_path(os.path.join(CUR_PATH, 'ver_ext_cfg/ver_ext_cfg.json'))
HALL_FLODERS = [
    {
        'from' : '$HALL_ROOT/src',
        'to' : 'src'
    },
    {
        'from' : '$HALL_ROOT/res',
        'to' : 'res'
    }
]

if __name__ == "__main__":
    from argparse import ArgumentParser
    parser = ArgumentParser(prog="gen-update-pack", description="Generate hot update package for hall")

    parser.add_argument("-v", dest="version", required=True, help="Specify the version of hall")

    (args, unknown) = parser.parse_known_args()

    ufd_file_path = flat_path(os.path.join(CUR_PATH, 'wlhall.ufd'))
    ufd_folder = os.path.dirname(ufd_file_path)
    if not os.path.isdir(ufd_folder):
        os.makedirs(ufd_folder)

    cmd = '%s -p %s --out-name %s --save --no-pack --exclude %s --ver-ext-cfg %s' % (TOOLS_PATH, ufd_file_path, args.version, EXCLUDE_FILE, DO_FILES_CFG)
    hall_folders = []
    hall_folders.extend(HALL_FLODERS)

    for cfg in hall_folders:
        from_cfg = cfg['from']
        to_cfg = cfg['to']
        from_cfg = from_cfg.replace('$PROJ_ROOT', PROJ_ROOT)
        from_cfg = from_cfg.replace('$CUR_PATH', CUR_PATH)
        from_cfg = from_cfg.replace('$HALL_ROOT', HALL_ROOT)
        from_path = flat_path(from_cfg)
        if not os.path.isdir(from_path):
            raise Exception('%s is not a valid directory.' % from_path)

        cmd += ' -s "%s;%s"' % (from_path, to_cfg)

    print("Running CMD: %s" % cmd)
    run_shell(cmd)

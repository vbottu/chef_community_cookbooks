# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2017 DennyZhang.com
## Licensed under MIT
##   https://www.dennyzhang.com/wp-content/mit_license.txt
##
## File : git_pull_codedir.py
## Author : Denny <contact@dennyzhang.com>
## Description :
## --
## Created : <2017-03-24>
## Updated: Time-stamp: <2017-09-07 21:37:47>
##-------------------------------------------------------------------
import os, sys
import sys
import logging
import argparse
# Notice: Need to run: pip install GitPython
import git

logger = logging.getLogger("git_pull_codedir")
formatter = logging.Formatter('%(name)-12s %(asctime)s %(levelname)-8s %(message)s', '%a, %d %b %Y %H:%M:%S',)
file_handler = logging.FileHandler("/var/log/git_pull_codedir.log")
file_handler.setFormatter(formatter)
stream_handler = logging.StreamHandler(sys.stderr)
logger.addHandler(file_handler)
logger.addHandler(stream_handler)
logger.setLevel(logging.INFO)

def git_pull(code_dir):
    logger.info("Run git pull in %s" %(code_dir))
    if os.path.exists(code_dir) is False:
        logger.error("Code directory(%s): doesn't exist" % (code_dir))
        sys.exit(1)
    os.chdir(code_dir)
    g = git.cmd.Git(code_dir)
    output = g.pull()
    return output

# Sample python git_pull_codedir.py --code_dirs "/data/code_dir/repo1,/data/code_dir/repo2"
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--code_dirs', required=True, \
                        help="Code directories to pull. If multiple, separated by comma", type=str)
    l = parser.parse_args()
    code_dirs = l.code_dirs

    separator = ","
    for code_dir in code_dirs.split(separator):
        git_output = git_pull(code_dir)
        if git_output == 'Already up-to-date.':
            has_changed = False
        else:
            has_changed = True
            logger.info("Code has changed in %s. Detail: %s" % (code_dir, git_output))

    if git_output is True:
        sys.exit(1)
    else:
        sys.exit(0)
## File : git_pull_codedir.py ends

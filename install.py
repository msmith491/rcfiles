#!/usr/bin/env python

from __future__ import (unicode_literals, print_function, division,
                        absolute_import)

import os
import re
import argparse

EXCLUDE = ["README.md", ".gitignore", "LICENSE", ".git", "install.py"]
DEFAULT_RE_EXCLUDE = [".*\.swp"]

parser = argparse.ArgumentParser()
parser.add_argument("--exclude", action="store", nargs="+",
                    help="Accepts a list of regex strings used to "
                    "exclude files from installing")
parser.add_argument("--uninstall", action="store_true",
                    help="Uninstall all tracked rcfiles [WIP]")
args = parser.parse_args()

if args.exclude:
    re_exclude = [elem for elem in args.exclude] + DEFAULT_RE_EXCLUDE
else:
    re_exclude = DEFAULT_RE_EXCLUDE

conf_files = ["/".join((os.path.dirname(os.path.abspath(__file__)), elem))
              for elem in os.listdir(".") if elem not in EXCLUDE]

filtered = []
for elem in conf_files:
    if not any([re.match(regex, elem) for regex in re_exclude]):
        filtered.append(elem)

if args.uninstall:
    for f in filtered:
        newfile = os.path.expanduser("~") + "/." + os.path.basename(f)
        if os.path.islink(newfile):
            print("Found {}...unlinking".format(newfile))
            os.unlink(newfile)
    exit(0)

for f in filtered:
    newfile = os.path.expanduser("~") + "/." + os.path.basename(f)
    # Backup any existing dotfiles we might overwrite, ignore symlinks
    if "nvimrc" in f:
        confdir = "/".join((os.path.expanduser("~"), ".config"))
        nvimdir = "/".join((confdir, "nvim"))
        nvimfile = "/".join((nvimdir, "init.vim"))
        if not os.path.isdir(confdir):
            os.makedirs(confdir)
        if not os.path.isdir(nvimdir):
            os.makedirs(nvimdir)
        if os.path.islink(nvimfile):
            print("Found existing symlink, skipping: {}".format(nvimfile))
            continue
        elif os.path.isfile(nvimfile):
            bakfile = nvimfile + ".bak"
            print("Found existing rcfile, renaming: {} --> {}".format(
                newfile, bakfile))
            os.rename(nvimfile, bakfile)
        os.symlink(f, nvimfile)
        print("symlinking:")
        print(f, nvimfile)
        continue
    if os.path.islink(newfile):
        print("Found existing symlink, skipping: {}".format(newfile))
        continue
    elif os.path.isfile(newfile):
        bakfile = newfile + ".bak"
        print("Found existing rcfile, renaming: {} --> {}".format(
            newfile, bakfile))
        os.rename(newfile, bakfile)
    print("symlinking:")
    print(f, "/".join((os.path.expanduser("~"), "." + os.path.basename(f))))
    os.symlink(f, "/".join((os.path.expanduser("~"), "." + os.path.basename(f))))
exit(0)

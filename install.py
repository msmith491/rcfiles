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

for f in filtered:
    print("symlinking:")
    print(f, "/".join((os.environ["HOME"], "." + os.path.basename(f))))
    os.symlink(f, "/".join((os.environ["HOME"], "." + os.path.basename(f))))

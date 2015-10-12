#!/usr/bin/env python

from __future__ import (unicode_literals, print_function, division,
                        absolute_import)

import os

EXCLUDE = ["README.md", ".gitignore", "LICENSE", ".git", "install.py"]

conf_files = [elem for elem in os.listdir(".") if elem not in EXCLUDE]

for f in conf_files:
    #os.symlink(f, "/".join((os.environ["HOME"], "." + f))
    print(f, "/".join((os.environ["HOME"], "." + f)))

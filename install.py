#!/usr/bin/env python

from __future__ import (unicode_literals, print_function, division,
                        absolute_import)

import os
import re

EXCLUDE = ["README.md", ".gitignore", "LICENSE", ".git", "install.py"]

RE_EXCLUDE = [".*\.swp"]

conf_files = ["/".join((os.path.dirname(os.path.abspath(__file__)), elem))
              for elem in os.listdir(".") if elem not in EXCLUDE]

filtered = []
for elem in conf_files:
    if not any([re.match(regex, elem) for regex in RE_EXCLUDE]):
        filtered.append(elem)

for f in filtered:
    print(f, "/".join((os.environ["HOME"] + "." + os.path.basename(f))))
    # os.symlink(f, "/".join((os.environ["HOME"] + "." + os.path.basename(f))))

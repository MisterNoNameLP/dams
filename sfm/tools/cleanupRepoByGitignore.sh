#!/bin/bash

git rm --cached `git ls-files -i -c --exclude-from=.gitignore`
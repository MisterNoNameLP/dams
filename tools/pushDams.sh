#!/bin/bash

# this pushes dams changes to the dams repo.
# there have to be a valid dams git repo at the $damsDir in order to work properly.

# conf
damsDir="../dams.git"
damsGitIgnore=".gitignore-dams"

# init
currentWorkingDir=$(pwd)

# copy files
rsync -rthuE ./ $damsDir \
    --exclude=".git" \
    --exclude=".gitignore" \
    --exclude=".gitignore-dams" \
    --filter=":- ${damsGitIgnore}"

cd $damsDir
#mv $damsGitIgnore .gitignore

#  push to dams repo
git add ./*
git commit -m "$@"
git push

# go back to current work dir
cd $currentWorkingDir
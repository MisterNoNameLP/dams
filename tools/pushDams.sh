#!/bin/bash
version="0.0d"

# this pushes dams changes to the dams repo.
# there have to be a valid dams git repo at the $damsDir in order to work properly.

# conf
branch="test"
damsDir="../dams.git"
damsGitIgnore=".gitignore-dams"

# init
currentWorkingDir=$(pwd)

# copy files
rsync -rthuE ${currentWorkingDir}/* $damsDir \
    --exclude=".git" \
    --exclude=".gitignore" \
    --exclude=".gitignore-dams" \
    --filter=":- ${damsGitIgnore}"

cd $damsDir
#mv $damsGitIgnore .gitignore

#  push to dams repo
git checkout $branch
mkdir -p templates/$branch
cp -r deamon/api templates/$branch
git add .
git commit -m "$@"
git push

# go back to current work dir
cd $currentWorkingDir
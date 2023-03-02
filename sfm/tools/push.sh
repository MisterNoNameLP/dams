#!/bin/bash

cp -r deamon/core/userData templates/dev
cp -r deamon/core/os templates/dev

git add .
git commit -m "$@"
git push

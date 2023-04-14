#!/bin/bash

cp -r deamon/data/userData templates/dev
cp -r deamon/data/os templates/dev

git add ./*
git commit -m "$@"
git push
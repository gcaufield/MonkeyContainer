#!/bin/bash
VERSION="v0.0.0"

docker build --no-cache -t "gcaufield/monkeycontainer:$VERSION" --build-arg vcs_rev=`git describe --long` --build-arg created=`date +"%Y-%m-%d"` .

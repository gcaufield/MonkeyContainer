#!/bin/bash
VERSION="v0.0.0"

docker build --no-cache -t "gcaufield/monkeycontainer:$VERSION" --label vcs_rev=`git describe --long` --label created=`date +"%Y-%m-%d"` .

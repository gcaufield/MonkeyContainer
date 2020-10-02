#!/bin/bash
VERSION="0.1.1"

docker build --no-cache -t "gcaufield/monkeycontainer:v$VERSION" --build-arg vcs_rev=`git describe --long` --build-arg created=`date +"%Y-%m-%d"` --build-arg version=$VERSION .

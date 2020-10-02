#!/bin/bash
VERSION="0.1.0"

docker build --no-cache -t "gcaufield/monkeycontainer:v$VERSION" --build-arg vcs_rev=`git describe --long` --build-arg created=`date +"%Y-%m-%d"` --build-arg version=$VERSION .

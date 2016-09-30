#!/usr/bin/env bash
docker run -it --privileged --rm --net=host -v /dev/shm:/dev/shm -v $(pwd):/protractor weremsoft/gulp-xvfb-headless-chrome-protractor $@
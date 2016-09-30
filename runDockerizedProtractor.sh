#!/bin/bash
export DISPLAY=:99
/etc/init.d/xvfb start
gulp protractor
RESULT=$?
/etc/init.d/xvfb stop
exit $RESULT
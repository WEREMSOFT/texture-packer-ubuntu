# Docker image to run gulp based protractor tests on a headless chrome.

Gulp Protractor end to end testing for AngularJS - dockerised with headless real Chrome.

This container is intended to be used as part of the building process, running e2e protractor tests in a jenkins task. But is not mandatory.

it have xvfb!
it have git!
it have protractor!
it have gulp!
it have nodejs!
it have jasmine!
it have mocha!
it have ubuntu!
it have google chrome!

But wait! there is more!!!

it have two scripts(check the git repo):

runDockerCommand.sh : Runs a command in the container, in your actual folder, inside the container!

runDockerizedProtractor.sh:  "gulp protractor" command, but first starts the xvfb service(to make google chrome believe that the container has a graphic UI ;-) ). You can replace the "gulp protractor" thing for another command you like, like "chrome facebook.com".


## Why headless Chrome?

PhantomJS is [discouraged by Protractor creators](https://angular.github.io/protractor/#/browser-setup#setting-up-phantomjs) and for a good reason. It's basically a bag of problems. 

## What is headless Chrome anyway?

To be perfectly honest - it is a [real chrome running on xvfb](http://tobyho.com/2015/01/09/headless-browser-testing-xvfb/). Therefore you have every confidence that the tests are run on the real thing.

# Usage

```
docker run -it --privileged --rm --net=host -v /dev/shm:/dev/shm -v $(pwd):/protractor weremsoft/gulp-xvfb-headless-chrome-protractor [command to run in the container]
```

This will run a command in your current directory, so you should run it in your tests root directory. It is useful to create a script, for example /usr/local/bin/protractor.sh such as this:

```
#!/bin/bash

docker run -it --privileged --rm --net=host -v /dev/shm:/dev/shm -v $(pwd):/protractor weremsoft/gulp-xvfb-headless-chrome-protractor $@
```

The script will allow you to run dockerised commands like so:

```
protractor.sh [commands like 'gulp protractor']
```

## Why mapping `/dev/shm`?

Docker has hardcoded value of 64MB for `/dev/shm`. Because of that you can encounter an error [session deleted becasue of page crash](https://bugs.chromium.org/p/chromedriver/issues/detail?id=1097) on memory intensive pages. The easiest way to mitigate that problem is share `/dev/shm` with the host.

This needs to be done till `docker build` [gets the option `--shm-size`](https://github.com/docker/docker/issues/2606).

## Why `--privileged`?

Chrome uses sandboxing, therefore if you try and run Chrome within a non-privileged container you will receive the following message:

"Failed to move to new namespace: PID namespaces supported, Network namespace supported, but failed: errno = Operation not permitted".

The [`--privileged`](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) flag gives the container almost the same privileges to the host machine resources as other processes running outside the container, which is required for the sandboxing to run smoothly.

## Why `--net=host`?

This options is required **only** if the dockerised Protractor is run against localhost on the host. Imagine this sscenario: you run an http test server on your local machine, let's say on port 8000. You type in your browser `http://localhost:8000` and everything goes smoothly. Then you want to run the dockerised Protractor against the same localhost:8000. If you don't use `--net=host` the container will receive the bridged interface and its own loopback and so the `localhost` within the container will refer to the container itself. Using `--net=host` you allow the container to share host's network stack and properly refer to the host when Protractor is run against `localhost`.


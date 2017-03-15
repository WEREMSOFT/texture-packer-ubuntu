FROM node:slim
MAINTAINER pablo.weremczuk@gmail.com
WORKDIR /tmp
RUN apt-get update
RUN apt-get install -y xvfb wget openjdk-7-jre
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg --unpack google-chrome-stable_current_amd64.deb
RUN apt-get install -f -y
RUN apt-get clean
RUN rm google-chrome-stable_current_amd64.deb
RUN apt-get install -y git
RUN apt-get install gdebi -f -y
RUN wget https://www.codeandweb.com/download/texturepacker/3.4.0/TexturePacker-3.4.0-ubuntu64.deb
RUN gdebi TexturePacker-3.4.0-ubuntu64.deb

RUN mkdir /protractor
# Fix for the issue with Selenium, as described here:
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

ENV DISPLAY :99

# Install Xvfb init script
ADD xvfb_init /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb
ADD xvfb-daemon-run /usr/bin/xvfb-daemon-run
RUN chmod a+x /usr/bin/xvfb-daemon-run

WORKDIR /protractor
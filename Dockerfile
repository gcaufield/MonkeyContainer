FROM ubuntu:bionic

ARG vcs_rev="dev"
ARG created=""
ARG sdk_ver="connectiq-sdk-lin-3.2.2-2020-08-28-a50584d55"
ARG version="development"

LABEL org.opencontainers.image.created="$created"
LABEL org.opencontainers.image.authors="Greg Caufield <greg@embeddedcoffee.ca>"
LABEL org.opencontainers.image.url="https://github.com/gcaufield/MonkeyContainer"
LABEL org.opencontainers.image.documentation="https://github.com/gcaufield/MonkeyContainer/wiki"
LABEL org.opencontainers.image.source="https://github.com/gcaufield/MonkeyContainer"
LABEL org.opencontainers.image.version="$version"
LABEL org.opencontainers.image.revision="$vcs_rev"

LABEL ca.embeddedcoffee.containers.monkey.ciqsdk.ver="$sdk_ver"

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y openjdk-11-jdk git
RUN apt-get install -y python3-pip python-dev
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y libpng16-16 libwebkitgtk-1.0-0 zlib1g-dev libc6-dev libstdc++6 libusb-dev
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y xorg xserver-xorg-video-dummy

COPY dummy-1920x1080.conf /etc/X11/xorg.conf
COPY scripts/start_display.sh /usr/bin/start_display

RUN sed -i "s/allowed_users=console/allowed_users=anybody/" /etc/X11/Xwrapper.config
ENV DISPLAY=:1

RUN pip3 install gdown mbpkg

RUN useradd -ms /bin/bash connectiq
WORKDIR /home/connectiq
USER connectiq

#ENV HOME="/home/connectiq/"
ARG sdk_base_url="https://developer.garmin.com/downloads/connect-iq/sdks"
ARG sdk_url="$sdk_base_url/$sdk_ver.zip"
ARG sdk_file="sdk.zip"
ARG sdk_dir="/home/connectiq/.Garmin/ConnectIQ/Sdks/${sdk_ver}"
ARG device_file="devices.zip"
ARG device_dir="/home/connectiq/.Garmin/ConnectIQ/"

ENV MB_HOME="${sdk_dir}"

RUN wget -O "${sdk_file}" "${sdk_url}"
RUN mkdir -p "${sdk_dir}"
RUN unzip "${sdk_file}" "*" -d "${sdk_dir}"

RUN gdown --id "1nDYmQqfE73wiSQJby5ZW4fkIfYc1ka6V" -O "${device_file}"
RUN mkdir -p "${device_dir}"
RUN unzip "${device_file}" "Devices/*" -d "${device_dir}"


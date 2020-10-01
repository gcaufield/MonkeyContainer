FROM ubuntu:bionic

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y openjdk-11-jdk git
RUN apt-get install -y python3-pip python-dev
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y libpng16-16 libwebkitgtk-1.0-0 zlib1g-dev libc6-dev libstdc++6 libusb-dev
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y xorg xserver-xorg-video-dummy x11-apps

COPY dummy-1920x1080.conf /etc/X11/xorg.conf
RUN sed -i "s/allowed_users=console/allowed_users=anybody/" /etc/X11/Xwrapper.config

RUN pip3 install gdown mbpkg

RUN useradd -ms /bin/bash connectiq
WORKDIR /home/connectiq
USER connectiq

#ENV HOME="/home/connectiq/"
ENV SDK_BASE_URL="https://developer.garmin.com/downloads/connect-iq/sdks"
ENV SDK="connectiq-sdk-lin-3.2.2-2020-08-28-a50584d55.zip"
ENV SDK_URL="$SDK_BASE_URL/$SDK"
ENV SDK_FILE="sdk.zip"
ENV SDK_DIR="/home/connectiq/.Garmin/ConnectIQ/Sdks/current"
ENV DEVICE_FILE="devices.zip"
ENV DEVICE_DIR="/home/connectiq/.Garmin/ConnectIQ/"

ENV PEM_FILE="/tmp/developer_key.pem"
ENV DER_FILE="/tmp/developer_key.der"

ENV MB_HOME="${SDK_DIR}"
ENV MB_PRIVATE_KEY="${DER_FILE}"

RUN wget -O "${SDK_FILE}" "${SDK_URL}"
RUN mkdir -p "${SDK_DIR}"
RUN unzip "${SDK_FILE}" "*" -d "${SDK_DIR}"
# RUN unzip "${SDK_FILE}" "share/*" -d "${SDK_DIR}"

RUN gdown --id "1nDYmQqfE73wiSQJby5ZW4fkIfYc1ka6V" -O "${DEVICE_FILE}"
RUN mkdir -p "${DEVICE_DIR}"
RUN unzip "${DEVICE_FILE}" "Devices/*" -d "${DEVICE_DIR}"

RUN openssl genrsa -out "${PEM_FILE}" 4096
RUN openssl pkcs8 -topk8 -inform PEM -outform DER -in "${PEM_FILE}" -out "${DER_FILE}" -nocrypt



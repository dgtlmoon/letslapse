# Maybe ubuntu is better here, unsure yet
FROM python:3.8-slim

RUN apt-get update

# Now continue like in https://github.com/dgtlmoon/letslapse/blob/7bd56546b2d8492a564a2da847ee6fc77fc5150b/install.sh#L17

# Install camera library depending on platform
RUN export dpkgArch="$(dpkg --print-architecture)" && echo "Build target is $dpkgArch"  \
  && case "${dpkgArch##*-}" in \
    amd64) echo unsure ;; \
    arm64) apt-get install python-picamera python3-picamera -y ;; \
    armv7l) apt-get install python-picamera python3-picamera -y ;; \
    *) echo "unsupported $dpkgArch "; exit 1 ;; \
  esac


RUN apt-get install libopenjp2-7 libopenjp2-7-dev libopenjp2-tools libatlas-base-dev -y

# OpenCV and dependencies
RUN apt-get install libtiff5 \
    libwebp-dev \
    libopenjp2-7 \
    libIlmImf-2_2-23 \
    libgstreamer1.0-dev \
    libopenexr-dev \
    python-opencv \
    ffmpeg \
    libimage-exiftool-perl -y

# Now the base libs are installed, now is a good time to install the python packages ontop
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt

# https://stackoverflow.com/questions/58701233/docker-logs-erroneously-appears-empty-until-container-stops
ENV PYTHONUNBUFFERED=1

RUN [ ! -d "/home/pi/letslapse" ] && mkdir -p /home/pi/letslapse

# The actual app
COPY . /home/pi/letslapse


WORKDIR /home/pi/letslapse

CMD [ "python", "./letslapse_server.py"]

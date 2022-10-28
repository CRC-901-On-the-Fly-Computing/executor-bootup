FROM ubuntu:18.04

LABEL maintainer="saman@mail.uni-paderborn.de"

## Update the container
RUN apt-get update
RUN apt-get install -y apt-utils

## Install packages 
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:cwchien/gradle
RUN apt-get update
RUN apt-get install -f
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y git
RUN apt-get install -y curl
RUN apt-get install -y build-essential
RUN apt-get install -y --allow-unauthenticated gradle
RUN rm -rf /var/lib/apt/lists/*


## We can get the bootup script from git repository (a)
## or copy them as files beside the image (b)
## or as volume for development (c)

## a. Clone the bootup scripts in current directory
## b. Or copy from the disk
# COPY . .

## c. Set the dev folder as a volume with a command like this:
## docker run -e SERVICE='catalano' -td --name task1-c task1-image \
## -v your-dev-path/executor-bootup:/sede

## Adding services config json file (Please see the example in current repo)
COPY config.json /temp/config.json

## Running Port
EXPOSE 8000

RUN mkdir /sede

RUN mkdir -p /temp

RUN touch /temp/startup.sh

RUN echo "#!/bin/bash" >> /temp/startup.sh

RUN echo "cd /sede" >> /temp/startup.sh

## a. Clone the bootup scripts in current directory, even if it is not empty
RUN echo "git init ." >> /temp/startup.sh
RUN echo "git remote add origin https://github.com/CRC-901-On-the-Fly-Computing/executor-bootup.git -master" >> /temp/startup.sh
RUN echo "git config remote.origin.fetch refs/heads/*:refs/remotes/origin/*" >> /temp/startup.sh
RUN echo "git fetch origin main && git pull origin main" >> /temp/startup.sh

RUN echo "cp /temp/config.json /sede/config.json" >> /temp/startup.sh

## Making sure all bash scripts will run properly (on the development mode you should run the command by yourself)
RUN echo "find . -type f -name '*.sh' | xargs chmod +x" >> /temp/startup.sh

RUN echo "./generate.sh" >> /temp/startup.sh

RUN chmod +x /temp/startup.sh

ARG executorName
ENV executorId $executorName
ENV useExecutorId "true"

ARG executionNamespace
ENV EXECUTION_NAMESPACE $executionNamespace

RUN echo $executorName
RUN echo $executorId

## Finally run the script inside the contianer
ENTRYPOINT ["./temp/startup.sh"]

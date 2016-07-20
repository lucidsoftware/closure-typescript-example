FROM ubuntu:14.04

RUN apt-get update && apt-get install -y openjdk-7-jdk build-essential git curl unzip nodejs vim python gyp

RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install -g npm

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN useradd -ms /bin/bash foo

ENV HOME /home/foo
USER foo

WORKDIR /home/foo

RUN git clone https://github.com/lucidsoftware/closure-typescript-example.git
RUN cd closure-typescript-example && make all -j 8
CMD cd closure-typescript-example && make run

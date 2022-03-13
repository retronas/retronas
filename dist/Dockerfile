FROM i386/debian:latest

RUN apt-get update
RUN apt-get install -y simple-cdd
RUN apt-get clean

RUN useradd -u 8877 retronas
USER retronas

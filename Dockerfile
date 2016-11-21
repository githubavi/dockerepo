#
# Ubuntu Dockerfile
#
# https://github.com/githubavi/dockerepo
#

# Pull base image.
FROM ubuntu:16.04

RUN echo "This is cool as I am doing my first autobuild docker image file"

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*
  
RUN apt-get update \
  && apt-get install -y apt-transport-https \
  && sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list' \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893 \
  && apt-get update \
  && apt-get install dotnet-dev-1.0.0-preview2.1-003177 \
  && mkdir hwapp \
  && cd hwapp \
  && dotnet new \
  && dotnet restore
  #dotnet run this is to run the console application

# Add files.
ADD README.md README.md
ADD HelloWorld.cs HelloWorld.cs
ADD .bashrc .bashrc
#ADD root/.gitconfig /root/.gitconfig
#ADD root/.scripts /root/.scripts

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]

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
  
RUN apt-get update 
RUN apt-get install -y apt-transport-https
RUN sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
RUN apt-get update



# Install .NET Core Runtime
ENV DOTNET_VERSION 1.1.0
#ENV DOTNET_DOWNLOAD_URL http://download.microsoft.com/download/A/F/6/AF610E6A-1D2D-47D8-80B8-F178951A0C72/Binaries/dotnet-ubuntu.16.04-x64.1.1.0.tar.gz
ENV https://dotnetcli.blob.core.windows.net/dotnet/release/1.1.0/Binaries/$DOTNET_VERSION/dotnet-ubuntu.16.04-x64.$DOTNET_VERSION.tar.gz

RUN curl -SL $DOTNET_DOWNLOAD_URL --output dotnet.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 1.0.0-preview2-1-003177
#ENV DOTNET_SDK_DOWNLOAD_URL http://download.microsoft.com/download/A/F/6/AF610E6A-1D2D-47D8-80B8-F178951A0C72/Binaries/dotnet-dev-ubuntu.16.04-x64.1.0.0-preview2-1-003177.tar.gz
ENV https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-dev-ubuntu.16.10-x64.$DOTNET_SDK_VERSION.tar.gz

RUN curl -SL $DOTNET_SDK_DOWNLOAD_URL --output dotnet.tar.gz \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz


#RUN apt-get install dotnet-dev-1.0.0-preview2.1-003177
RUN mkdir hwapp
RUN cd hwapp
RUN dotnet new
RUN dotnet restore
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

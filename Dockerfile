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

# Install .NET CLI dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libc6 \
        libcurl3 \
        libgcc1 \
        libgssapi-krb5-2 \
        liblttng-ust0 \
        libssl1.0.0 \
        libstdc++6 \
        libunwind8 \
        libuuid1 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*


# Install .NET Core Runtime
ENV DOTNET_VERSION 1.1.0
ENV DOTNET_DOWNLOAD_URL http://download.microsoft.com/download/A/F/6/AF610E6A-1D2D-47D8-80B8-F178951A0C72/Binaries/dotnet-ubuntu.16.04-x64.1.1.0.tar.gz
#ENV DOTNET_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/release/1.1.0/Binaries/$DOTNET_VERSION/dotnet-ubuntu.16.04-x64.$DOTNET_VERSION.tar.gz

RUN curl -SL $DOTNET_DOWNLOAD_URL --output dotnet.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 1.0.0-preview2-1-003177
ENV DOTNET_SDK_DOWNLOAD_URL http://download.microsoft.com/download/A/F/6/AF610E6A-1D2D-47D8-80B8-F178951A0C72/Binaries/dotnet-dev-ubuntu.16.04-x64.1.0.0-preview2-1-003177.tar.gz
#ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-dev-ubuntu.16.10-x64.$DOTNET_SDK_VERSION.tar.gz

RUN curl -SL $DOTNET_SDK_DOWNLOAD_URL --output dotnet.tar.gz \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz

# Trigger the population of the local package cache
ENV NUGET_XMLDOC_MODE skip
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE true
RUN mkdir warmup \
    && cd warmup \
    && dotnet new \
    # Projects created with .NET Core SDK preview3 target 1.0, replace with 1.1 to populate cache
    # && sed -i "s/1.0.1/1.1.0/;s/netcoreapp1.0/netcoreapp1.1/" ./warmup.csproj \
    && dotnet restore \
    && cd .. \
    && rm -rf warmup \
    && rm -rf /tmp/NuGetScratch

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

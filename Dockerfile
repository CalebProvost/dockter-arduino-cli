# Dockerized Arduino CLI. For more info see https://arduino.github.io/arduino-cli/latest/
FROM ubuntu:18.04

# Install build system's dependencies
RUN apt-get update && \
    apt-get -y upgrade

# Install Dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    curl \
    file \
    git \
    sudo \
    locales

# User management
RUN adduser --disabled-password --gecos '' user
RUN adduser user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set environment
RUN dpkg-reconfigure locales
RUN locale-gen en_US.UTF-8
ENV LANG en_us.UTF-8
ENV LC_ALL en_US.UTF-8
RUN update-locale
USER user
WORKDIR /home/user

# Install Arduino CLI
RUN curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash
RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/user/.profile
ENV PATH=$PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin
RUN brew update && brew install arduino-cli

# Configure Arduino CLI
RUN arduino-cli config init && \
    # https://arduino.github.io/arduino-cli/latest/getting-started/#connect-the-board-to-your-pc
    arduino-cli core update-index && \
    arduino-cli board list --format json

CMD [ "bash", "-c", "arduino-cli board list --format json" ]

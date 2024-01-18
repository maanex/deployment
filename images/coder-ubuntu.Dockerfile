FROM ubuntu:20.04

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
        bash \
        build-essential \
        ca-certificates \
        curl \
        htop \
        locales \
        man \
        python3 \
        python3-pip \
        software-properties-common \
        sudo \
        systemd \
        systemd-sysv \
        unzip \
        vim \
        cmake \
        openjdk-8-jdk \
        maven \
        wget \
        snapd \
    # Install latest Git using their official PPA
    && add-apt-repository ppa:git-core/ppa \
    && DEBIAN_FRONTEND="noninteractive" apt-get install --yes git

# Install Google Cloud CLI
# RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
#     && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /usr/share/keyrings/cloud.google.asc \
#     && apt-get update -y \
#     && apt-get install google-cloud-sdk -y \
#     && apt-get install google-cloud-cli-app-engine-java -y

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && DEBIAN_FRONTEND="noninteractive" apt-get update -y \
    && apt-get install -y nodejs

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install -y yarn

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash

# Install Ngrok
RUN  curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
    && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list \
    && sudo apt install ngrok

# Add a user `coder` so that you're not developing as the `root` user
RUN useradd coder \
    --create-home \
    --shell=/bin/bash \
    --uid=1000 \
    --user-group \
    && echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

USER coder

RUN mkdir /home/coder/repos

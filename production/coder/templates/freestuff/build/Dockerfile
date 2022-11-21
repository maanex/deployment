FROM ubuntu

# RUN apt-get update \
# 	&& apt-get install -y \
# 	curl \
# 	git \
# 	sudo \
# 	wget \
# 	&& rm -rf /var/lib/apt/lists/*
RUN apt-get update \
RUN apt-get install -y curl
RUN apt-get install -y git
RUN apt-get install -y sudo
RUN apt-get install -y wget
RUN rm -rf /var/lib/apt/lists/*

ARG USER=coder
RUN useradd --groups sudo --no-create-home ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}
USER ${USER}
WORKDIR /home/${USER}
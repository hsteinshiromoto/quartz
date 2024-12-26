FROM alpine:3.20 

ARG BUILD_DATE
ARG USER=user
# ---
# Enviroment variables
# ---
ENV LANG=C.UTF-8 \
	LC_ALL=C.UTF-8
ENV TZ Australia/Sydney
ENV USER=$USER
SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash
ENV HOME=/home/$USER
ENV WORKDIR=$HOME/workspace
ENV QUARTZ=$HOME/quartz
ENV PATH="${PATH}:${QUARTZ}"

LABEL org.label-schema.build-date=$BUILD_DATE \
	maintainer="hsteinshiromoto@gmail.com"

# Create the "home" folder
RUN mkdir -p $WORKDIR

# ---
# Instal Alpine Dependencies
# ---
RUN apk add --update bash git shadow xz


# ---
# install nix package manager
# ---
COPY bin/get_nix.sh /usr/local/bin
RUN chmod +x /usr/local/bin/get_nix.sh && bash /usr/local/bin/get_nix.sh

# ---
# Install Nix Packages
# ---
RUN nix-env -iA nixpkgs.musl nixpkgs.nodejs_22 nixpkgs.zsh

# ---
# Install Quartz
# ---
RUN git clone https://github.com/jackyzha0/quartz.git $QUARTZ \
	&& cd $QUARTZ \
	&& npm i
# && npx quartz create

EXPOSE 8080
CMD ["tail", "-f","/dev/null"]

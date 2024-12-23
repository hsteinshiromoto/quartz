FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=user
# ---
# Enviroment variables
# ---
ENV LANG=C.UTF-8 \
	LC_ALL=C.UTF-8
ENV TZ Australia/Sydney
SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash
ENV HOME=/home/$USER
ENV QUARTZ=/usr/local/quartz
ENV PATH="${PATH}:$QUARTZ"


# Create the "home" folder
RUN mkdir -p $HOME
COPY . $HOME
WORKDIR $HOME

# ---
# Install pyenv
#
# References:
#   [1] https://stackoverflow.com/questions/65768775/how-do-i-integrate-pyenv-poetry-and-docker
# ---
# Install pyenv dependencies
RUN apt-get update && \
	apt-get install -y build-essential libssl-dev zlib1g-dev \
	libbz2-dev libreadline-dev libsqlite3-dev curl llvm \
	libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev git python3-pip && \
	apt-get clean

RUN git clone --depth=1 https://github.com/pyenv/pyenv.git $HOME/.pyenv
ENV PYENV_ROOT="${HOME}/.pyenv"
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"

# ---
# Install NodeJS
# ---

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
RUN apt-get update && \
	apt-get install -y nodejs

# Get poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="${PATH}:$HOME/.poetry/bin"
ENV PATH="${PATH}:$HOME/.local/bin"

RUN poetry config virtualenvs.create false
# && cd /usr/local \
# && poetry install --no-interaction --no-ansi

ENV PATH="${PATH}:$HOME/.local/bin"

# Need for Pytest
ENV PATH="${PATH}:${PYENV_ROOT}/versions/$PYTHON_VERSION/bin"

# ---
# Install Quartz
# ---
RUN git clone https://github.com/jackyzha0/quartz.git $QUARTZ \
	&& cd $QUARTZ \
	&& npm i
# && npx quartz create

EXPOSE 8080

FROM    ubuntu:jammy

# Build Arguments
ARG     DEFAULT_CC
ARG     DEFAULT_EDITOR
ARG     ROOT_PWD
ARG     GID0
ARG     GID0_NAME
ARG     UID0
ARG     UID0_PWD
ARG     UID0_NAME
ARG     UID0_GECOS
ARG     UID1
ARG     UID1_PWD
ARG     UID1_NAME
ARG     UID1_GECOS
ARG     UID2
ARG     UID2_PWD
ARG     UID2_NAME
ARG     UID2_GECOS

# Set 'root' password
RUN     echo "root:${ROOT_PWD}" | chpasswd

# APT-GET options
ARG     APTGET_OPTS="-y --no-install-recommends"
ARG     APTGET_INSTALL="apt-get install ${APTGET_OPTS}"

# Update APT-GET package lists
RUN     export DEBIAN_FRONTEND=noninteractive \
        && apt-get update ${APTGET_OPTS} \
        && apt-get upgrade ${APTGET_OPTS}

# Users & groups
RUN     addgroup --gid ${GID0} ${GID0_NAME} \
        && adduser --uid ${UID0} --gid ${GID0} --gecos "${UID0_GECOS}" ${UID0_NAME} \
                && echo "${UID0_NAME}:${UID0_PWD}" | chpasswd \
        && adduser --uid ${UID1} --gid ${GID0} --gecos "${UID1_GECOS}" ${UID1_NAME} \
                && echo "${UID1_NAME}:${UID1_PWD}" | chpasswd \
        && adduser --uid ${UID2} --gid ${GID0} --gecos "${UID2_GECOS}" ${UID2_NAME} \
                && echo "${UID2_NAME}:${UID2_PWD}" | chpasswd \
        && apt-get install ${APTGET_OPTS} sudo \
        && echo "${GID0_NAME} ALL=(ALL) ALL" >> /etc/sudoers

# Essential packages
RUN     apt-get install ${APTGET_OPTS} build-essential clang emacs-nox network-manager vim

# Libraries & other packages
RUN     apt-get ${APTGET_OPTS} clean \
        && apt-get ${APTGET_OPTS} autoremove

RUN     apt-get install ${APTGET_OPTS} libmagic-dev openssl \
        && apt-get install ${APTGET_OPTS} curl wget \
        && apt-get install ${APTGET_OPTS} python3 python3-pip

# Set preferences
RUN     echo "export CC=\"${DEFAULT_CC}\"" >> /etc/bash.bashrc

RUN     DEFAULT_EDITOR_PATH=$(which ${DEFAULT_EDITOR}) \
        && update-alternatives --install /usr/bin/editor editor ${DEFAULT_EDITOR_PATH} 100 \
        && update-alternatives --set editor ${DEFAULT_EDITOR_PATH}

# Project file
COPY    --chown=root:${GID0_NAME} --chmod=775 src /srv/pastree

# Build project
RUN     make -C  /srv/pastree \
        && ln -s /srv/pastree/server /usr/local/bin/server

# Default user and working directory
USER    ${UID0_NAME}
WORKDIR /home/${UID0_NAME}

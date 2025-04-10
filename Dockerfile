# vim:set ft=dockerfile:

# Do not edit individual Dockerfiles manually. Instead, please make changes to the Dockerfile.template, which will be used by the build script to generate Dockerfiles.

FROM ubuntu:22.04

LABEL maintainer="Vijay <vijay@circleci.com>"

# Change default shell for RUN from Dash to Bash
SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

ARG HELM_INSTALL_VERSION

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=dumb \
    PAGER=cat \
    HELM_INSTALL_VERSION=$3.11.2 \
    YQ_VERSION=4.31.2

# Configure environment
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90circleci && \
    echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90circleci && \
    apt-get update && apt-get install -y \
    curl \
    locales \
    sudo \
    && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/* && \
    \
    groupadd --gid=1002 circleci && \
    useradd --uid=1001 --gid=circleci --create-home circleci && \
    echo 'circleci ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-circleci && \
    echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep && \
    sudo -u circleci mkdir /home/circleci/project && \
    sudo -u circleci mkdir /home/circleci/bin && \
    sudo -u circleci mkdir -p /home/circleci/.local/bin && \
    \
    dockerizeArch=arm64 && \
    if uname -p | grep "x86_64"; then \
    dockerizeArch=x86_64; \
    fi && \
    curl -sSL --fail --retry 3 --output /usr/local/bin/dockerize "https://github.com/powerman/dockerize/releases/download/v0.8.0/dockerize-linux-${dockerizeArch}" && \
    chmod +x /usr/local/bin/dockerize && \
    dockerize --version

ENV PATH=/home/circleci/bin:/home/circleci/.local/bin:$PATH \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN noInstallRecommends="" && \
    if [[ "22.04" == "22.04" ]]; then \
    noInstallRecommends="--no-install-recommends"; \
    fi && \
    apt-get update && apt-get install -y $noInstallRecommends \
    autoconf \
    build-essential \
    ca-certificates \
    cmake \
    # already installed but here for consistency
    curl \
    file \
    gettext-base \
    gnupg \
    gzip \
    jq \
    libcurl4-openssl-dev \
    libmagic-dev \
    # popular DB lib - MariaDB
    libmariadb-dev \
    # allows MySQL users to use MariaDB lib
    libmariadb-dev-compat \
    # popular DB lib - PostgreSQL
    libpq-dev \
    libssl-dev \
    libsqlite3-dev \
    lsof \
    make \
    # for ssh-enabled builds
    nano \
    net-tools \
    netcat \
    openssh-client \
    parallel \
    # compiling tool
    pkg-config \
    postgresql-client \
    python-is-python3 \
    shellcheck \
    software-properties-common \
    # already installed but here for consistency
    sudo \
    tar \
    tzdata \
    unzip \
    # for ssh-enabled builds
    vim \
    wget \
    zip && \
    # get the semi-official latest-stable git instead of using the old(er) version from the ubuntu distro
    add-apt-repository ppa:git-core/ppa && apt-get install -y git && \
    # get the semi-official latest-stable git-lfs too
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && apt-get install -y git-lfs && \
    # Quick test of the git & git-lfs install
    git version && git lfs version && \
    # Smoke test for python aliasing
    python --version && \
    rm -rf /var/lib/apt/lists/*

# Install Docker - needs the setup_remote_docker CircleCI step to work
ENV DOCKER_VERSION 5:20.10.23~3-0~ubuntu-
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository -y "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $( lsb_release -cs ) stable" && \
    apt-get install -y docker-ce=${DOCKER_VERSION}$( lsb_release -cs ) docker-ce-cli=${DOCKER_VERSION}$( lsb_release -cs ) containerd.io && \
    # Quick test of the Docker install
    docker --version && \
    rm -rf /var/lib/apt/lists/*

# Install PHP extensions, XVFB, and global npm packages
RUN apt-get update && apt-get install -y \
    php-cli \
    php-xml \
    php-curl \
    php-xdebug \
    xvfb \
    npm && \
    echo "zend_extension=$(find /usr/lib/php/ -name xdebug.so)" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    npm install -g junit-viewer && \
    rm -rf /var/lib/apt/lists/*

# Install Docker Compose - see prerequisite above
ENV COMPOSE_VER 2.17.2
ENV COMPOSE_SWITCH_VERSION 1.0.5
RUN dockerPluginDir=/usr/local/lib/docker/cli-plugins && \
    mkdir -p $dockerPluginDir && \
    curl -sSL "https://github.com/docker/compose/releases/download/v${COMPOSE_VER}/docker-compose-linux-$(uname -m)" -o $dockerPluginDir/docker-compose && \
    chmod +x $dockerPluginDir/docker-compose && \
    curl -fL "https://github.com/docker/compose-switch/releases/download/v${COMPOSE_SWITCH_VERSION}/docker-compose-linux-$(dpkg --print-architecture)" -o /usr/local/bin/compose-switch && \
    # Quick test of the Docker Compose install
    docker compose version && \
    chmod +x /usr/local/bin/compose-switch && \
    update-alternatives --install /usr/local/bin/docker-compose docker-compose /usr/local/bin/compose-switch 99 && \
    # Tests if docker-compose for v1 is transposed to v2
    docker-compose version

RUN curl -sSL "https://github.com/mikefarah/yq/releases/download/v4.31.2/yq_linux_amd64.tar.gz" | \
    tar -xz -C /usr/local/bin && \
    mv /usr/local/bin/yq{_linux_amd64,}

# Install helm version 3.11.2
RUN curl -LO https://get.helm.sh/helm-v3.11.2-linux-amd64.tar.gz && \
    tar -zxvf helm-v3.11.2-linux-amd64.tar.gz && \
    sudo mv linux-amd64/helm /usr/local/bin/helm

RUN helm plugin install https://github.com/databus23/helm-diff

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    kubectl version --client

RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && \
    sudo mv /tmp/eksctl /usr/local/bin && \
    eksctl version

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install && \
    aws --version

RUN wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list && \
    sudo apt update && sudo apt install terraform

USER circleci
# Run commands and tests as circleci user
RUN whoami && \
    # opt-out of the new security feature, not needed in a CI environment
    git config --global --add safe.directory '*'

# Match the default CircleCI working directory
WORKDIR /home/circleci/project
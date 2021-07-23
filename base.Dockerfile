FROM ubuntu:focal-20210713 as base
# hadolint ignore=SC1072,DL3008,DL4006
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends gnupg2 curl ca-certificates apt-transport-https openssh-client locales && \
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8 && \
  echo 'deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main' > /etc/apt/sources.list.d/git.list && \
  echo 'deb https://packagecloud.io/github/git-lfs/ubuntu/ focal main' > /etc/apt/git-lfs.list && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
  curl -fsSL https://packagecloud.io/github/git-lfs/gpgkey | gpg --dearmor -o /usr/share/keyrings/github-git-lfs-6B05F25D762E3157.gpg && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24 && \
  echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  focal stable" | tee /etc/apt/sources.list.d/docker.list && \
  apt-get update &&  \
  apt-get install -y --no-install-recommends git git-lfs zsh docker-ce-cli && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
# hadolint ignore=DL3022
COPY --from=hadolint/hadolint:2.6.0 /bin/hadolint /usr/bin/
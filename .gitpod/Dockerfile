FROM gitpod/workspace-full
USER root

RUN mkdir $HOME/bin
RUN npm install -g @bazel/bazelisk
RUN npm install -g @bazel/ibazel
RUN npm install -g http-server

RUN apt-get update
RUN apt-get install -y zsh && \
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ENV GOPATH=/workspace/
ENV GNUPGHOME=/tmp/gnupg

ARG BAZEL_BUILDTOOLS_VERSION
ARG BAZEL_BUILDTOOLS_URL="https://github.com/bazelbuild/buildtools/releases/download/"
RUN curl -sSL "${BAZEL_BUILDTOOLS_URL}/${BAZEL_BUILDTOOLS_VERSION}/buildozer" > /usr/local/bin/buildozer && \
    curl -sSL "${BAZEL_BUILDTOOLS_URL}/${BAZEL_BUILDTOOLS_VERSION}/buildifier" >  /usr/local/bin/buildifier && \
    chmod +x /usr/local/bin/buildozer && \
    chmod +x /usr/local/bin/buildifier 

RUN wget -O $HOME/bin/gostarlark https://github.com/stackb/bzl/releases/download/0.9.4/bzl && \
  chmod +x $HOME/bin/gostarlark

RUN curl -sSL "https://github.com/c4milo/github-release/releases/download/v1.1.0/github-release_v1.1.0_linux_amd64.tar.gz" > /tmp/github-release.tar.gz && \
    tar -xvf /tmp/github-release.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/github-release

USER gitpod
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ENV BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
    BOOTSTRAP_HASKELL_GHC_VERSION=recommended \
    BOOTSTRAP_HASKELL_CABAL_VERSION=recommended \
    BOOTSTRAP_HASKELL_INSTALL_STACK=1 \
    BOOTSTRAP_HASKELL_INSTALL_HLS=1 \
    BOOTSTRAP_HASKELL_ADJUST_BASHRC=1 \
    PATH="/root/.ghcup/bin:/root/.cabal/bin:${PATH}"

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
       build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev \
       zlib1g-dev pkg-config \
    && rm -rf /var/lib/apt/lists/* \
    && curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
FROM rocker/tidyverse:3.5.3

USER root

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.39.0

RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='7d610882f67ec4e53a56a8177d7862501a043f80be7ba13b6e325cc9921f23b8' ;; \
        armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='3bc5c5fff32113dc20284bd605eb2a6f7070de0c69c742b00b0ca4511a8fbc4c' ;; \
        arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='cff57e155046439896004d7eb66fcbebe436f00298b1dacef426aef0a109a866' ;; \
        i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='2d82bf50439c6ec74af4a5642a004fe8915921b52d3ec54032e0dc10476718c1' ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.18.1/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain $RUST_VERSION; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

ENV DART_VERSION 2.6.1-1

RUN \
  apt-get -q update && apt-get install --no-install-recommends -y -q gnupg2 curl git ca-certificates apt-transport-https openssh-client && \
  curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list && \
  apt-get update && \
  apt-get install dart=$DART_VERSION && \
  rm -rf /var/lib/apt/lists/*

ENV DART_SDK /usr/lib/dart
ENV PATH $DART_SDK/bin:$PATH

RUN apt-get update && apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common  && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - && \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable" && \
    apt-get update && \
    apt-get install -y docker-ce && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install renv
# see https://github.com/tercen/log_operator/blob/master/renv/activate.R
ENV RENV_PATHS_LIBRARY="/usr/local/lib/R/renv/library"
RUN mkdir -p ${RENV_PATHS_LIBRARY}/R-3.5/x86_64-pc-linux-gnu
RUN R -e "remotes::install_github('rstudio/renv@0.9.2-19', lib='${RENV_PATHS_LIBRARY}/R-3.5/x86_64-pc-linux-gnu')"

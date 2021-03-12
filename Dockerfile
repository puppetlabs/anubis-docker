FROM puppet/pdk:nightly

RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

RUN ["useradd", "--create-home", "--home-dir", "/anubis", "--shell", "/bin/bash", "--user-group", "anubis"]
USER anubis

ENV PATH="${PATH}:/opt/puppetlabs/pdk/private/git/bin"
ENV PDK_DISABLE_ANALYTICS=true

WORKDIR /anubis

RUN ["mkdir", "-p", "entrypoints", "shared", "workspace"]

ADD entrypoints entrypoints/
ADD shared shared/

FROM ubuntu:18.04

RUN apt-get update -y

# install deps for erlang 22.3.2 and install erlang
RUN apt-get install -y --no-install-recommends curl ca-certificates autoconf tar wget gnupg2 libsctp1 libwxgtk3.0-dev make inotify-tools
RUN wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_22.3.2-1~ubuntu~bionic_amd64.deb
RUN dpkg -i esl-erlang_22.3.2-1~ubuntu~bionic_amd64.deb

# install erlang
RUN apt-get install -y --no-install-recommends esl-erlang

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.10.2" \
  LANG=C.UTF-8

# install elixir
RUN set -xe \
  && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
  && ELIXIR_DOWNLOAD_SHA256="5adffcf4389aa82fcfbc84324ebbfa095fc657a0e15b2b055fc05184f96b2d50" \
  && curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
  && echo "$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha256sum -c - \
  && mkdir -p /usr/local/src/elixir \
  && tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
  && rm elixir-src.tar.gz \
  && cd /usr/local/src/elixir \
  && make install clean

RUN mix local.hex --force
# RUN mix archive.install hex phx_new 1.4.16

# install node 
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN npm install --global yarn 
RUN mix local.rebar --force

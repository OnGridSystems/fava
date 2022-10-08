FROM python:3.9-buster as builder

WORKDIR /fava
# Set fallback mount directory
ENV MNT_DIR /mnt/gcs

RUN apt update -y
RUN apt install -y curl libxml2-dev libxslt-dev gcc musl-dev g++ make git npm tini lsb-release
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash
RUN apt install -y nodejs

# install google fuse bucket client
RUN set -e; \
    gcsFuseRepo=gcsfuse-`lsb_release -c -s`; \
    echo "deb http://packages.cloud.google.com/apt $gcsFuseRepo main" | \
    tee /etc/apt/sources.list.d/gcsfuse.list; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key add -; \
    apt-get update; \
    apt-get install -y gcsfuse

COPY . .
RUN mv ./entrypoint.sh /entrypoint.sh
RUN make
RUN pip install .

ENV FAVA_HOST "0.0.0.0"
ENV PORT 5000

EXPOSE $BLOCKCHAIN_ID
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

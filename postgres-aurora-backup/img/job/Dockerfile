FROM ubuntu:22.04

# Install pre-reqs
RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-setuptools \
        wget \
    && pip3 install --upgrade pip \
    && apt-get clean

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list

RUN apt-get update
RUN apt-get install -y postgresql-client-14
RUN apt-get clean

RUN pip3 --no-cache-dir install --upgrade awscli

COPY scripts/ /scripts/

CMD /bin/bash /scripts/backup-postgres.sh

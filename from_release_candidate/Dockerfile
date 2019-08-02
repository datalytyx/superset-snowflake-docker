FROM python:3.6-jessie

RUN useradd --user-group --create-home --no-log-init --shell /bin/bash superset

# Configure environment
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update -y

# Install dependencies to fix `curl https support error` and `elaying package configuration warning`
RUN apt-get install -y apt-transport-https apt-utils

# Install superset dependencies
# https://superset.incubator.apache.org/installation.html#os-dependencies
RUN apt-get install -y build-essential libssl-dev \
    libffi-dev python3-dev libsasl2-dev libldap2-dev libxi-dev

# Install nodejs for custom build
# https://superset.incubator.apache.org/installation.html#making-your-own-build
# https://nodejs.org/en/download/package-manager/
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs

RUN mkdir -p /home/superset
RUN chown superset /home/superset

WORKDIR /home/superset
ARG VERSION

RUN svn co https://dist.apache.org/repos/dist/dev/incubator/superset/$VERSION ./
RUN tar -xvf *.tar.gz
WORKDIR apache-superset-incubating-$VERSION

RUN cd superset/assets \
    && npm ci \
    && npm run build \
    && rm -rf node_modules


WORKDIR /home/superset/apache-superset-incubating-$VERSION
RUN pip install --upgrade setuptools pip \
    && pip install -r requirements.txt -r requirements-dev.txt \
    && pip install -e . \
    && rm -rf /root/.cache/pip
    
RUN pip install snowflake-sqlalchemy

RUN fabmanager babel-compile --target superset/translations

RUN pip install -e . \
    && rm -rf /root/.cache/pip

ENV PATH=/home/superset/superset/bin:$PATH \
    PYTHONPATH=/home/superset/superset/:$PYTHONPATH
COPY entrypoint.sh /entrypoint.sh
EXPOSE 8088
ENTRYPOINT ["/entrypoint.sh"]
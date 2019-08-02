FROM python:3.6

# Superset version
ARG SUPERSET_VERSION=0.28.1

# Configure environment
ENV GUNICORN_BIND=0.0.0.0:8088 \
    GUNICORN_LIMIT_REQUEST_FIELD_SIZE=0 \
    GUNICORN_LIMIT_REQUEST_LINE=0 \
    GUNICORN_TIMEOUT=60 \
    GUNICORN_WORKERS=2 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONPATH=/etc/superset:/home/superset:$PYTHONPATH \
    SUPERSET_REPO=apache/incubator-superset \
    SUPERSET_VERSION=${SUPERSET_VERSION} \
    SUPERSET_HOME=/var/lib/superset
ENV GUNICORN_CMD_ARGS="--workers ${GUNICORN_WORKERS} --timeout ${GUNICORN_TIMEOUT} --bind ${GUNICORN_BIND} --limit-request-line ${GUNICORN_LIMIT_REQUEST_LINE} --limit-request-field_size ${GUNICORN_LIMIT_REQUEST_FIELD_SIZE}"
RUN w

# Create superset user & install dependencies
RUN useradd -U -m superset && \
    mkdir /etc/superset  && \
    mkdir ${SUPERSET_HOME} && \
    chown -R superset:superset /etc/superset && \
    chown -R superset:superset ${SUPERSET_HOME} && \
    apt-get update && \
    apt-get install -y \
        build-essential \
        curl \
        default-libmysqlclient-dev \
        freetds-bin \
        freetds-dev \
        libffi-dev \
        libldap2-dev \
        libpq-dev \
        libsasl2-2 \
        libsasl2-dev \
        libsasl2-modules-gssapi-mit \
        libssl1.0
RUN   apt-get upgrade -y
RUN   apt-get clean
RUN   rm -r /var/lib/apt/lists/
RUN    curl https://raw.githubusercontent.com/${SUPERSET_REPO}/${SUPERSET_VERSION}/requirements.txt -o requirements.txt
RUN    pip install --no-cache-dir -r requirements.txt
RUN    rm requirements.txt
RUN     pip install oauthlib --upgrade
RUN     pip install cryptography --upgrade
RUN     pip install --no-cache-dir \
        flask-cors \
        flask-mail \
        flask-oauth \
        flask_oauthlib \
        gevent \
        impyla \
        infi.clickhouse-orm \
        mysqlclient \
        psycopg2 \
        pyathena \
        pybigquery \
        pyhive \
        pyldap \
        pymssql \
        redis \
        sqlalchemy-clickhouse \
        sqlalchemy-redshift \
        snowflake-sqlalchemy \
        werkzeug
RUN    pip install superset==${SUPERSET_VERSION}

# Configure Filesystem
COPY superset /usr/local/bin
VOLUME /home/superset \
       /etc/superset \
       /var/lib/superset
WORKDIR /home/superset

# Deploy application
EXPOSE 8088
HEALTHCHECK CMD ["curl", "-f", "http://localhost:8088/health"]
CMD ["gunicorn", "superset:app"]

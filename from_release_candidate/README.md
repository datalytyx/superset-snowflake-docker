# Apache Releases

To make a working build given a tarball (release candidate), see https://github.com/apache/incubator-superset/releases for versions
```bash
# Building a docker from a tarball
VERSION=0.33.0rc1 && \
docker build -t apache-superset:$VERSION -f Dockerfile . --build-arg VERSION=$VERSION

# testing the resulting docker
docker run -p 8088:8088 apache-superset:0.33.0rc2
# you should be able to access localhost:8088 on your browser
# login using admin/admin
```

Be aware Entrypoint.sh currently creates the user with admin/admin

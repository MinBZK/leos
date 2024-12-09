# General note: for now, install everything in one container, this needs to be different containers per process
# We should make this a multistage build, but for now, this is fine.
FROM --platform=$BUILDPLATFORM ubuntu:24.04

ARG TARGETARCH
ARG LEOS_VERSION=5.1.3
ARG ANNOTATED_VERSION=5.1.0

RUN apt-get update && apt-get install -y maven nodejs npm openjdk-8-jdk

# todo: fix for amd64
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-$TARGETARCH
ENV PATH=$JAVA_HOME/bin:$PATH

ENV MAVEN_CLI_OPTS="--batch-mode --errors --fail-at-end --show-version"

ADD assets/annotate-Annotate_${ANNOTATED_VERSION}.tar.gz /app
ADD assets/core-LEOS_${LEOS_VERSION}.tar.gz /app

RUN ln -s /app/core-LEOS_${LEOS_VERSION}/ /app/leos
RUN ln -s /app/annotate-Annotate_${ANNOTATED_VERSION}/ /app/annotate


RUN cd /app/leos/tools/user-repo && mvn clean install -DskipTests -q
RUN cd /app/leos/tools/repository && mvn clean install -DskipTests -q
RUN cd /app/leos/ && mvn clean install -DskipTests -q
RUN cd /app/leos/tools/akn4euutil && mvn clean install -DskipTests -q

# RUN cd /app/annotate && mvn clean install -Denv=local -q -DskipTests

WORKDIR /app/leos

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# ENTRYPOINT [ "/app/entrypoint.sh" ]
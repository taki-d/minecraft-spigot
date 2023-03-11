ARG ALPINE_VERSION=3.17.2

FROM alpine:${ALPINE_VERSION} AS builder
ARG SPIGOT_VERSION=1.19.3
RUN apk --update --no-cache --progress -q add openjdk17-jre git
RUN wget -q https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
RUN java -Xmx1024M -jar BuildTools.jar --rev ${SPIGOT_VERSION}

FROM alpine:$ALPINE_VERSION
ARG SPIGOT_VERSION=1.19.3
RUN apk --update --no-cache --progress -q add openjdk17-jre && \
    rm -rf /var/cache/apk/*
ENV JAVA_OPTS -Xms512m -Xmx1800m -XX:+UseConcMarkSweepGC \
    ACCEPT_EULA=false \
    SPIGOT_VERSION=1.19.3
COPY --from=builder "/spigot-${SPIGOT_VERSION}.jar" /spigot.jar
WORKDIR /spigot

ENTRYPOINT echo "eula=$ACCEPT_EURA" > eula.txt && \
    java -jar /spigot.jar nogui




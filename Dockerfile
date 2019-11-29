FROM openjdk:8

ARG SCALA_VERSION=2.10.6
ARG SBT_VERSION=0.13.13

VOLUME /usr/src
VOLUME /root/.ivy2
WORKDIR /usr/src

RUN curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc && \
  curl -fsL -o sbt-$SBT_VERSION.deb http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install -y sbt && \
  apt-get clean && \
  sbt sbtVersion

# Define working directory
WORKDIR /usr/src
ENTRYPOINT ["sbt"]

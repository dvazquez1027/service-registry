FROM maven:3.6-openjdk-11 AS BUILD
WORKDIR /tmp
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src/ src/
RUN mvn -q package

FROM openjdk:11.0.9
ARG JAVA_OPTS
ENV JAVA_OPTS=$JAVA_OPTS
COPY --from=BUILD /tmp/target/service-registry.war service-registry.war
EXPOSE 8761
ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar service-registry.war

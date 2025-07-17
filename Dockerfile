# 1. Build Stage: Use Maven to build the application
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# 2. Final Stage: Use a slim JRE for the final image
FROM openjdk:17-jre-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
# We will pass the commit SHA in via Kubernetes environment variables
ENV COMMIT_SHA=""
ENTRYPOINT ["java", "-jar", "app.jar"]

# Use a multi-stage build for a lean production image

# 1. Build Stage: Use Maven to build the application
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# 2. Final Stage: Use a stable and slim JRE for the final image
# UPDATED LINE: Switched from 'openjdk' to the more reliable 'eclipse-temurin'
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

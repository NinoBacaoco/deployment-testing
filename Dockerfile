# Build stage
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml . 
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM openjdk:17.0.1-jdk-slim
WORKDIR /app
COPY --from=build /app/target/testdeploy-0.0.1-SNAPSHOT.jar app.jar

# Create directories for file storage (if needed)
RUN mkdir -p /app/files /app/certificates

# Expose port
EXPOSE 8080

# Environment variables will be injected by Render
ENTRYPOINT ["java", "-jar", "app.jar"]

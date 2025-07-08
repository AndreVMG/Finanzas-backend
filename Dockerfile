# Etapa 1: construir el JAR
FROM gradle:8.7.0-jdk17 AS builder
WORKDIR /app

# Copiar el proyecto con los archivos del wrapper incluidos
COPY --chown=gradle:gradle . .

# Dar permisos al wrapper
RUN chmod +x gradlew

# Usar el wrapper para construir el JAR
RUN ./gradlew bootJar --no-daemon

# Etapa 2: imagen liviana para correr la app
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

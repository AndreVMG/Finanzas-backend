# Etapa 1: construir el JAR
FROM gradle:8.7.0-jdk17 AS builder
WORKDIR /app

# Copiar todos los archivos necesarios para el build
COPY --chown=gradle:gradle . .

# Construir el .jar sin ejecutar tests
RUN gradle bootJar --no-daemon

# Etapa 2: imagen final para ejecutar el JAR
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copiar solo el jar generado
COPY --from=builder /app/build/libs/*.jar app.jar

# Exponer el puerto
EXPOSE 8080

# Ejecutar el JAR
ENTRYPOINT ["java", "-jar", "app.jar"]

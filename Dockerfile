# -------- BUILD STAGE --------
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Install git (needed for cloning submodule)
RUN apt-get update && apt-get install -y git

# Copy repo
COPY . .

# Clone submodule + build
RUN git clone https://github.com/geofabrik/railway-routing-api.git doc/api \
    && mvn -q clean package -DskipTests

# -------- RUNTIME STAGE --------
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy built jar
COPY --from=builder /app/target/*jar-with-dependencies.jar /app/app.jar

# Railway-friendly defaults
ENV JAVA_OPTS="-Xms512m -Xmx2g"

# Port GraphHopper uses
EXPOSE 8989

# Run server
CMD ["sh", "-c", "java $JAVA_OPTS -jar app.jar serve config.yml"]

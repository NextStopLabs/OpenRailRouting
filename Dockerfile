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

# Install wget for downloading OSM data at runtime
RUN apt-get update && apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*

# Copy built jar
COPY --from=builder /app/target/*jar-with-dependencies.jar /app/app.jar

# Copy config
COPY --from=builder /app/config.yml /app/config.yml

# Railway-friendly defaults
ENV JAVA_OPTS="-Xms50m -Xmx2500m"

# Port GraphHopper uses
EXPOSE 8989

# Run server — download OSM file on first run if not present on volume
CMD ["sh", "-c", "if [ ! -f /data/britain-and-ireland-latest.osm.pbf ]; then echo 'Downloading OSM file...' && wget -O /data/britain-and-ireland-latest.osm.pbf https://download.geofabrik.de/europe/britain-and-ireland-latest.osm.pbf; fi && java $JAVA_OPTS -Ddw.graphhopper.datareader.file=/data/britain-and-ireland-latest.osm.pbf -jar app.jar serve config.yml"]

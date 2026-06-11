FROM eclipse-temurin:17-jdk

WORKDIR /app

# Install curl (THIS fixes your error)
RUN apt-get update && apt-get install -y curl

# Copy project
COPY . .

# Build app
RUN ./mvnw clean package -DskipTests || mvn clean package -DskipTests

# Create data dir
RUN mkdir -p /data

# Download SMALL dataset (important)
RUN curl -L https://download.geofabrik.de/europe-latest.osm.pbf \
    -o /data/europe-latest.osm.pbf

# Run app
CMD ["java","-Xms50m","-Xmx2500m","-Ddw.graphhopper.datareader.file=/data/europe-latest.osm.pbf","-jar","target/railway_routing-1.1.jar","serve","config.yml"]

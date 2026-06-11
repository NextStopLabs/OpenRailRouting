FROM eclipse-temurin:17-jdk

WORKDIR /app

# Install curl + maven (THIS fixes your build failure)
RUN apt-get update && apt-get install -y curl maven

# Copy project files
COPY . .

# Build the jar (no mvnw fallback needed anymore)
RUN mvn clean package -DskipTests

# Create data directory
RUN mkdir -p /data

# Download dataset (this will work, but may be slow/huge)
RUN curl -L https://download.geofabrik.de/europe-latest.osm.pbf \
    -o /data/europe-latest.osm.pbf

# Start app
CMD ["java","-Xms50m","-Xmx2500m","-Ddw.graphhopper.datareader.file=/data/europe-latest.osm.pbf","-jar","target/railway_routing-1.1.jar","serve","config.yml"]

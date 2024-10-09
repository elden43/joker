# Base image with Go for compiling the app
FROM golang:1.23.2-bookworm AS builder

WORKDIR /app

# Copy Go source codes and build the application
COPY go.mod .
RUN if [ -f go.sum ]; then cp go.sum .; fi
RUN go mod download

COPY . .

RUN go build -o joker .

# Use lightweight image for the final running of the application
FROM debian:bookworm-slim

# Install Supervisor and Nginx
RUN apt-get update && apt-get install -y nginx supervisor && rm -rf /var/lib/apt/lists/*

# Copy the compiled application
RUN mkdir -p /usr/local/bin/joker && mkdir -p /usr/local/bin/joker/data
COPY --from=builder /app/joker /usr/local/bin/joker/joker
COPY --from=builder /app/data/jokes.json /usr/local/bin/joker/data/jokes.json

# Copy configuration files
COPY .build/nginx/nginx.conf /etc/nginx/nginx.conf
COPY .build/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set port for Nginx
EXPOSE 80

# Run both Nginx and Supervisor
CMD ["/usr/bin/supervisord", "-n"]
# Base image with Go for compiling the app
FROM golang:1.23.2-bookworm AS builder

# Nastav pracovní adresář
WORKDIR /app

# Zkopíruj Go zdrojové kódy a zbuilduj aplikaci
COPY go.mod .
RUN if [ -f go.sum ]; then cp go.sum .; fi
RUN go mod download

COPY . .

RUN go build -o joker .

# Použij lightweight image pro finální běh aplikace
FROM debian:bookworm-slim

# Nainstaluj Supervisor a Nginx
RUN apt-get update && apt-get install -y nginx supervisor && rm -rf /var/lib/apt/lists/*

# Zkopíruj zkompilovanou aplikaci
RUN mkdir -p /usr/local/bin/joker && mkdir -p /usr/local/bin/joker/data
COPY --from=builder /app/joker /usr/local/bin/joker/joker
COPY --from=builder /app/data/jokes.json /usr/local/bin/joker/data/jokes.json

# Zkopíruj konfigurační soubory
COPY .build/nginx/nginx.conf /etc/nginx/nginx.conf
COPY .build/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Nastav port pro Nginx
EXPOSE 80

# Spusť jak Nginx, tak Supervisor
CMD ["/usr/bin/supervisord", "-n"]

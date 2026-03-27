FROM alpine:latest

ARG PB_VERSION=0.36.6

RUN apk add --no-cache \
    unzip \
    ca-certificates

# download and unzip PocketBase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/

# uncomment to copy the local pb_migrations dir into the image
# COPY ./pb_migrations /cloud/storage/pb_migrations

# uncomment to copy the local pb_hooks dir into the image
# COPY ./pb_hooks /cloud/storage/pb_hooks

# uncomment to copy the local pb_public dir into the image
# COPY ./pb_public /cloud/storage/pb_public

ENV HOST 0.0.0.0
ENV PORT 8080

# Start-Skript erstellen
RUN echo '#!/bin/sh' > /pb/start.sh && \
    echo '/pb/pocketbase superuser upsert ${PB_ADMIN_EMAIL} ${PB_ADMIN_PASSWORD}' >> /pb/start.sh && \
    echo 'exec /pb/pocketbase serve --http="0.0.0.0:8080" --dir=/cloud/storage/pb_data --publicDir=/cloud/storage/pb_public --hooksDir=/cloud/storage/pb_hooks' >> /pb/start.sh && \
    chmod +x /pb/start.sh

EXPOSE 8080

ENTRYPOINT ["/pb/start.sh"]

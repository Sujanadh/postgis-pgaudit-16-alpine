FROM postgis/postgis:16-3.4-alpine

# Install necessary packages required to build pg_audit
RUN apk add --no-cache --virtual .build-deps git make gcc musl-dev postgresql-dev krb5-dev libc-dev llvm15 clang15

RUN git clone https://github.com/pgaudit/pgaudit.git

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=pgaudit-16

# Build and install pgAudit
WORKDIR /pgaudit
RUN git checkout REL_16_STABLE
RUN make check USE_PGXS=1
RUN make install USE_PGXS=1 PG_CONFIG=/usr/local/bin/pg_config
RUN apk del .build-deps

# Clean up
WORKDIR /
RUN rm -rf pgaudit

# Copy init script to set up pgAudit extension
COPY ./init-pgaudit.sh /docker-entrypoint-initdb.d/init-pgaudit.sh

# Expose the default PostgreSQL port
EXPOSE 5432
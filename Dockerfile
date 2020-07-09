FROM docker.io/ubuntu:20.04 as builder
ENV version=7.0.4

ADD https://dl.grafana.com/oss/release/grafana-${version}.linux-amd64.tar.gz /tmp/grafana_${version}.tar.gz
RUN apt-get update && apt install -y ca-certificates && \
    tar xvzf /tmp/grafana_${version}.tar.gz -C /tmp && \
    mv /tmp/grafana-${version} /grafana && \
    mkdir -p /grafana/data/logs
RUN /grafana/bin/grafana-cli --pluginsDir /grafana/data/plugins plugins install alexanderzobnin-zabbix-app && \
    /grafana/bin/grafana-cli --pluginsDir /grafana/data/plugins plugins install grafana-clock-panel && \
    /grafana/bin/grafana-cli --pluginsDir /grafana/data/plugins plugins install ryantxu-ajax-panel && \
    /grafana/bin/grafana-cli --pluginsDir /grafana/data/plugins plugins install briangann-gauge-panel && \
    /grafana/bin/grafana-cli --pluginsDir /grafana/data/plugins plugins install grafana-piechart-panel && \
    /grafana/bin/grafana-cli --pluginsDir /grafana/data/plugins plugins install camptocamp-prometheus-alertmanager-datasource && \
    /grafana/bin/grafana-cli --pluginsDir /grafana/data/plugins plugins install grafana-polystat-panel && \
    /grafana/bin/grafana-cli --pluginsDir /grafana/data/plugins plugins install simpod-json-datasource && \
    /grafana/bin/grafana-cli --pluginsDir /grafana/data/plugins plugins install michaeldmoore-multistat-panel

# Basic distroless debian10 image
FROM gcr.io/distroless/base-debian10

# Maintaincer label
LABEL maintainer="Dominik Lenhardt <dom@onkeldom.eu>"

# Set environment variables
ENV PATH="/grafana/bin:$PATH"
ENV GF_PATHS_CONFIG="/grafana/conf/grafana.ini"
ENV GF_PATHS_DATA="/grafana/data"
ENV GF_PATHS_HOME="/grafana"
ENV GF_PATHS_PLUGINS="/grafana/data/plugins"
ENV GF_PATHS_PROVISIONING="/grafana/conf/provisioning"

# Copy from builder
COPY --chown=nonroot:nonroot --from=builder /grafana /grafana

# Application defaults
WORKDIR /grafana
EXPOSE 3000

CMD [ \
     "/grafana/bin/grafana-server", \
     "-homepath=/grafana" \
    ]

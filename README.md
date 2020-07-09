# distroless-prometheus

Automatic build for distroless grafana container

## Volumes

```
/app = application folder with /app/<command>
/config = config folder with /config/<app>.ext
/data = data forlder with /data volume mount
```

## Default CMD
```
CMD [ \
     "/grafana/bin/grafana-server", \
     "-homepath=/grafana" \
    ]
```

## Installed plugins
```
alexanderzobnin-zabbix-app
grafana-clock-panel
ryantxu-ajax-panel
briangann-gauge-panel
grafana-piechart-panel
camptocamp-prometheus-alertmanager-datasource
grafana-polystat-panel
simpod-json-datasource
michaeldmoore-multistat-panel
```

## Automatic release check with cron
```
# Create two files:
# .telegram_token with your token
# .telegram_chatid with your chat id
# Clone repo and exec hourly cronjob
$ echo "@hourly /home/onkeldom/git-repos/distroless-grafana/get_release.sh 2>&1 | logger -t build_grafana" | sudo tee /etc/cron.d/build_grafana
```

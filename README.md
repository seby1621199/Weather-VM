# Weather Info Linux
## Steps:

### 1 Create variable

Command: ```sudo nano /etc/default/weather ```


Content: 
```
CITY=Timisoara
```

### 2 Create /usr/local/sbin/weather.sh
Command: sudo nano /usr/local/sbin/weather.sh

Content:
```
#!/bin/bash
set -euo pipefail

LOGFILE="/var/log/weather.log"

if [ -f /etc/default/weather ]; then
    source /etc/default/weather
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Fisierul /etc/default/weather nu exista" >> "$LOGFILE"
    exit 1
fi

if [ -z "$CITY" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Variabila CITY nu este definita in /etc/default/weather" >> "$LOGFILE"
    exit 1
fi

UPTIME=$(uptime -p)
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5 " used of " $2}')
WEATHER=$(curl -s "https://wttr.in/$CITY?format=3")

{
echo "==== Welcome to your Dev VM ===="
echo "City: $CITY"
echo "Weather today: $WEATHER"
echo "Hostname: $(hostname)"
echo "Current time: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Uptime: $UPTIME"
echo "Disk usage: $DISK_USAGE"
echo "==============================="
} > /etc/motd

echo "$(date '+%Y-%m-%d %H:%M:%S') - Fetched weather for $CITY: $WEATHER" >> "$LOGFILE"

```

You need to change permission: ``` chmod +x /usr/local/sbin/weather.sh  ```

### 3 Create a .service for weather
Command : ``` sudo nano /etc/systemd/system/weather.service ```

Content: 
```
[Unit]
Description=Show weather after boot
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/weather.sh
EnvironmentFile=/etc/default/weather

[Install]
WantedBy=multi-user.target
```

Commands after to load service:
```
sudo systemctl daemon-reload
sudo systemctl enable weather.service
sudo systemctl start weather.service
```

### How to use it:
After reboot you can check /etc/motd using command: ``` cat /etc/motd ``` and you will see information about weather in format: 
```
==== Welcome to your Dev VM ====
City: Timisoara
Weather today: Timisoara: ☀️   +20°C
Hostname: ip-172-31-21-182.eu-north-1.compute.internal
Current time: 2025-08-19 11:22:51
Uptime: up 0 minutes
Disk usage: 3% used of 100G
===============================
```
To see logs ``` cat /var/log/weather.log```




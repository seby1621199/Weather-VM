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

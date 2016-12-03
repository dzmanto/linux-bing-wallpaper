#!/bin/sh
( crontab -l ; echo "@reboot /usr/bin/bing_wallpaper.sh" ) | crontab - 2>&1 >/dev/null

#!/bin/sh
( crontab -l | grep ^"\/usr\/bin\/bing_wallpaper.sh" ) | crontab -

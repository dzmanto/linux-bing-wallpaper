# Linux-bing-wallpaper

## Name
linux-bing-wallpaper - set the <a href="http://www.bing.com">bing</a> wallpaper of the day as your desktop wallpaper

![][bangimage]
[bangimage]: http://download-codeplex.sec.s-msft.com/Download?ProjectName=bang&DownloadId=1436017

## Synopsis

bing_wallpaper.sh [market,runonce]

## Description

The linux-bing-wallpaper shell script sets the <a href="http://www.bing.com">bing</a> wallpaper of the day as your Mac OSX® or linux desktop. It features support for Mac OSX®, <a href="https://www.ubuntu.com/">Ubuntu</a> Unity®, <a href="https://www.gnome.org/">GNOME (2 and 3)</a>, <a href="http://mate-desktop.org/">Mate</a>, <a href="https://www.kde.org/">KDE4</a>, and <a href="http://xfce.org/">XFCE4</a>.

## Options

Linux-bing-wallpaper comes with two options <b>market</b> and <b>runonce</b>. If <b>market</b> is specified, <b>runonce</b> will have to be specified as well. That is, the two options <b>market</b> and <b>runonce</b> may either be specified together or not at all.

<b>market</b>: <a href="http://www.bing.com">Bing</a> provides wallpapers for a range of regional markets. Users may specify a value for the  <b>market</b> option that matches their region. Linux-bing-wallpaper accepts the following values for the <b>market</b> option: de_CH, de_DE, en_AU, en_CA, en_NZ, en_UK, en-US, ja_JP, and zh_CN.

<b>runonce</b>: If a value for the <b>market</b> option has been specified, a value will also be expected for the <b>runonce</b> option. The value for the <b>runonce</b> option can be either true or false. If set to true, linux-bing-wallpaper will run once and stop. If set to false, linux-bing-wallpaper will run every twelve hours. If your machine is down at the time linux-bing-wallpaper tries to load a wallpaper, execution will be delayed until your computer wakes up.

## Example
The command
```
bing-wallpaper.sh en-US true
```
will download a <a href="http://www.bing.com">bing</a> wallpaper of the day destined for the US. The script will download the wallpaper, set it as your desktop wallpaper, and then exit.

The command
```
bing-wallpaper.sh en-US false
```
will download a <a href="http://www.bing.com">bing</a> wallpaper of the day destined for the US. The script will download the wallpaper, and set it as your desktop wallpaper. Linux-bing-wallpaper will try and load another wallpaper of the day every twelve hours.

## Installation

Download the <a href="https://github.com/dzmanto/linux-bing-wallpaper/blob/master/bing_wallpaper.sh">bing_wallpaper.sh</a> script.

Put it somewhere (such as the folder /usr/bin).

Give the script execution permissions (chmod +x).

Make it autostart (see the below comments for Mac OSX®, in <a href="https://www.ubuntu.com/">Ubuntu</a> gnome-session-properties is your friend).

The next time you start your machine, linux-bing-wallpaper will run.

## Commands for installation & first steps
```
# change to target folder
cd /usr/bin
su
# download the script
wget https://raw.githubusercontent.com/dzmanto/linux-bing-wallpaper/master/bing_wallpaper.sh -o bin/bing_wallpaper.sh
# mark the script as executable
chmod +x bin/*.sh
exit

# Run linux-bing-wallpaper with default settings
/usr/bin/bing_wallpaper.sh

# The first parameter indicates market.
# Setting the second parameter to true indicates immediate exit.
# The script will otherwise sleep for twelve hours.
/usr/bin/bing_wallpaper.sh en-US true
```

## autostart through cron the easy way (tried and tested also on Mac OSX® computers)
```
( crontab -l ; echo "@reboot /usr/bin/bing_wallpaper.sh" ) | crontab - 2>&1 >/dev/null
```

## autostart through cron, if the easy way does not work (crontab -e for your user)
```
@reboot /usr/bin/bing_wallpaper.sh
```
<p>A similar solution is <a href="https://github.com/dzmanto/bang">available</a> for Microsoft Windows® machines. </p>

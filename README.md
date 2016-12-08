# Linux-bing-wallpaper shell script

The linux-bing-wallpaper shell script sets the <a href="http://www.bing.com">bing</a> wallpaper of the day as your Mac OSX® or linux desktop.

It supports Mac OSX®, <a href="https://www.ubuntu.com/">Ubuntu</a> Unity®, GNOME (2 and 3) <a href="https://www.kde.org/">KDE4</a>, and <a href="http://xfce.org/">XFCE4</a>.

## Installation

Download the <a href="https://github.com/dzmanto/linux-bing-wallpaper/blob/master/bing_wallpaper.sh">bing_wallpaper.sh</a> script.

Put it somewhere (such as the folder /usr/bin)

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

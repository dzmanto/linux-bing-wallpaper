# Linux Bing Wallpaper Shell Scripts

It sets the <a href="http://www.bing.com">bing</a> wallpaper of the day as your Mac OSX® or linux desktop.

It supports Mac OSX®, <a href="https://www.ubuntu.com/">Ubuntu</a> Unity®, GNOME (2 and 3) <a href="https://www.kde.org/">KDE4</a>, and <a href="http://xfce.org/">XFCE4</a>.

## Installation

Download the shell .sh scripts.

Put them somewhere (/usr/bin for example)

Give the scripts execution permissions (chmod +x).

Make them autostart (see the below comments for Mac OSX®, gnome-session-properties is your friend in <a href="https://www.ubuntu.com/">Ubuntu</a>).

So next time you start your machine, linux-bing-wallpaper will run once.

## Commands for installation & first steps
```
cd /usr/bin
su
# download the script
wget https://raw.githubusercontent.com/dzmanto/linux-bing-wallpaper/master/bing_wallpaper.sh -o bin/bing_wallpaper.sh
# mark the script as executable
chmod +x bin/*.sh
exit

# Run linux-bing-wallpaper with default settings
/usr/bin/bing_wallpaper.sh

# The first parameter is market
# Set the second parameter to true indicate immediate exit immediately
# (otherwise, script will sleep for 12 hours)
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

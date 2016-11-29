# Linux Bing Wallpaper Shell Scripts

It sets the <a href="http://www.bing.com">bing</a> wallpaper of the day as your Mac OSX or linux desktop.

It supports Mac OSX, Ubuntu Unity, GNOME (2 and 3) KDE4, and XFCE4.

## Usage

Download these two scripts.

Put them somewhere (/usr/bin for example)

Change mkt varible in bing_wallpaper.sh to your market (valid values are: en-US, zh-CN, ja-JP, en-AU, en-UK, de-DE, en-NZ, en-CA)

Give the scripts execution permissions.

Make them autostart. (see the below comments for Mac OSX, gnome-session-properties is your friend on Ubuntu)

So next time you boot your computer for the first time a day, it will run once.

## Installation & first steps
```
cd /usr, /bin
su
wget https://raw.githubusercontent.com/dzmanto/linux-bing-wallpaper/master/bing_wallpaper.sh -o bin/bing_wallpaper.sh
# If you use KDE
wget https://raw.githubusercontent.com/dzmanto/linux-bing-wallpaper/master/kde4_set_wallpaper.sh -o bin/kde4_set_wallpaper.sh
chmod +x bin/*.sh
exit

# Default behavior
/usr/bin/bing_wallpaper.sh

# First param is Market
# Second param is true to exit immediately if you want to use a cron
# (otherwise, script will sleep 24 hrs)
/usr/bin/bing_wallpaper.sh en-US true
```

## Example cron autostart (crontab -e for your user, run at startup, tried and tested also on Mac OSX computers)
```
@ reboot /usr/bin/bing_wallpaper.sh
```

## Example cron usage (crontab -e for your user)
```
# m h dom mon dow command
* * * * * /usr/bin/bing_wallpaper.sh en-US true
```
<p>A similar solution is <a href="https://github.com/dzmanto/bang">available</a> for Microsoft Windows machines. </p>

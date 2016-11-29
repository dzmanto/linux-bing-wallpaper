# Linux Bing Wallpaper Shell Scripts

It sets www.bing.com wallpaper of the say as your linux desktop

supports Mac OSX, Ubuntu Unity, GNOME (2 and 3) KDE4, and XFCE4.

## Usage

Download these two scripts.

Put them somewhere (/usr/bin for example)

Change mkt varible in bing_wallpaper.sh to your market (valid values are: en-US, zh-CN, ja-JP, en-AU, en-UK, de-DE, en-NZ, en-CA)

Give the scripts execution permissions.

Make them autostart. (Google is your friend)

So next time you boot your computer for the first time a day, it'll run once.

Next boots it will run too, but do nothing.

## Easy commands
```
cd /usr/bin
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

## Example cron usage (crontab -e for your user, run at startup, tried and tested also on Mac OSX computers)
```
@ reboot /usr/bin/bing_wallpaper.sh
```

## Example cron usage (crontab -e for your user)
```
# m h dom mon dow command
* * * * * /usr/bin/bing_wallpaper.sh en-US true
```

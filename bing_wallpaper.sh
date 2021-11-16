#!/bin/sh
# Author: Marguerite Su <i@marguerite.su>, dzmanto <dzmanto@hotmail.com>
# License: GPL-3.0
# Description: Download bing wallpaper of the day and set it as your linux desktop.
# https://github.com/dzmanto/linux-bing-wallpaper/

# global options

# $bing is needed to form the fully qualified URL for
# the Bing pic of the day
bing="www.bing.com"

# The idx parameter determines where to start from. 0 is the current day,
# 1 the previous day, etc.
idx="0"

# Set picture options
# Valid options are: none,wallpaper,centered,scaled,stretched,zoom,spanned
picOpts="stretched"

# the file extension for the Bing pic
picExt=".jpg"

# tackle zsh particularities
rake='noglob rake'

# tackle two more zsh particularities
if [ "$ZSH_NAME" = "zsh" ]; then
	setopt +o nomatch
	set -o shwordsplit
fi

contains() {
    local value=$(eval "echo \$$#")
    count=1
    for i in $*
     do
        if [ "$i" = "$value" -a $count -lt $# ]; then
            echo "y"
            return 0
        fi
 	count=$(expr $count + 1)
    done
    echo "n"
    return 1
}


checkdep() {
	tool=$(which $1)
	if [ ! -x "$tool" ]; then
		echo "Linux-bing-wallpaper depends on $1."
		echo "Install $1, please."
		echo "Exit."
		exit 1
	fi
}

ctfn () {
	if [ -d $HOME/.cache ]; then
		tfnns=$(mktemp $HOME/.cache/bing_wallpaper_XXXXXX)
	else	
		tfnns=$(mktemp /tmp/bing_wallpaper_XXXXXX)
	fi	
	tfn="$tfnns$picExt"
	mv "$tfnns" "$tfn"
	echo "$tfn"
}

detectDE() {
    # see https://bugs.freedesktop.org/show_bug.cgi?id=34164
    unset GREP_OPTIONS

    uname -a | grep -i darwin 2>&1 >/dev/null && DE="mac";

    if [ -n "${XDG_CURRENT_DESKTOP}" ]; then
      case "${XDG_CURRENT_DESKTOP}" in
         'GNOME'|'gnome')
           DE="gnome"
           ;;
         'KDE'|'kde')
           DE="kde"
           ;;
         'LXDE'|'lxde')
           DE="lxde"
           ;;
         'LXQt'|'lxqt')
           DE="lxqt"
           ;;
         'MATE'|'mate')
           DE="mate"
           ;;
         'XFCE'|'xfce')
           DE="xfce"
           ;;
         'X-Cinnamon'|'x-cinnamon')
           DE="cinnamon"
           ;; 
      esac
    fi

    if [ -z "$DE" ]; then
      # classic fallbacks
      if [ x"$KDE_FULL_SESSION" = x"true" ]; then DE="kde";
      elif [ x"$GNOME_DESKTOP_SESSION_ID" != x"" ]; then DE="gnome";
      elif [ x"$MATE_DESKTOP_SESSION_ID" != x"" ]; then DE="mate";
      elif `dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.GetNameOwner string:org.gnome.SessionManager > /dev/null 2>&1` ; then DE="gnome";
      elif xprop -root _DT_SAVE_MODE 2> /dev/null | grep ' = \"xfce4\"$' >/dev/null 2>&1; then DE="xfce";
      elif xprop -root 2> /dev/null | grep -i '^xfce_desktop_window' >/dev/null 2>&1; then DE="xfce";
      fi
    fi

    if [ -z "$DE" ]; then
      # fallback to checking $DESKTOP_SESSION
     case "$DESKTOP_SESSION" in
         'gnome')
           DE="gnome"
           ;;
         'LXDE'|'Lubuntu'|'lxde'|'lubuntu')
           DE="lxde"
           ;;
         'MATE'|'mate')
           DE="mate"
           ;;
         'xfce'|'xfce4'|'Xfce Session'|'xfce session')
           DE="xfce"
           ;;
      esac
    fi

    if [ x"$DE" = x"gnome" ]; then
      # gnome-default-applications-properties is only available in GNOME 2.x
      # but not in GNOME 3.x
      which gnome-default-applications-properties > /dev/null 2>&1  || DE="gnome3"
    fi
    
    # DE not found, maybe used WM
    if [ -z "$DE" ]; then
     	DE="WM"
    fi
    
    echo $DE
}

doof () {
	if [ -d $HOME/.cache ]; then
		find $HOME/.cache/bing_wallpaper_*.jpg -mtime +1 -delete 2>&1 >/dev/null
	else	
		find /tmp/bing_wallpaper_*.jpg -mtime +1 -delete 2>&1 >/dev/null
	fi	
}

helpme() {
echo "Usage: bing_wallpaper.sh [market runonce]"
echo "Generic option:"
echo "       --help show this help"
echo "Wallpaper parameters:"
echo "       market: de-DE, en-AU, en-CA, en-NZ, en-UK, en-US, ja-JP, or zh-CN"
echo "       runonce: true or false"
echo "       Note that market and runonce must be specified together or not at all."
}

sanity() {
        tool=$(which sed)
        if [ ! -x "$tool" ]; then
                return $1
        fi
        original_string=$1
	result_string=$(echo "$original_string" | sed -e 's|&amp;|vrumfodel_placeholder|g')
	result_string=$(echo "$result_string" | sed -e 's|&apos;|pos_placeholder|g')
	result_string=$(echo "$result_string" | sed -e 's|&nbsp;|space_placeholder|g')
	result_string=$(echo "$result_string" | sed -e 's|&quot;|quotation_placeholder|g')
	result_string=$(echo "$result_string" | sed -e 's|\r||g')     
	result_string=$(echo "$result_string" | sed 's|;||g')
        result_string=$(echo "$result_string" | sed 's|&||g')
        result_string=$(echo "$result_string" | sed 's/|//g')
	result_string=$(echo "$result_string" | sed -e 's|vrumfodel_placeholder|\&amp;|g')
	result_string=$(echo "$result_string" | sed -e 's|apos_placeholder|\&apos;|g')
	result_string=$(echo "$result_string" | sed -e 's|space_placeholder|\&nbsp;|g')
	result_string=$(echo "$result_string" | sed -e 's|quotation_placeholder|\&quot;|g')
	result_string=$(echo "$result_string" | sed -e 's|^www|https://www|g')
        echo "$result_string"
}

for i in $*
do
if [ "$i" = "-h" -o "$i" = "-help" -o "$i" = "--help" -o "$i" = "-help" ]; then
	helpme
	exit
fi
done

checkdep "curl"
checkdep "egrep"

if [ $# -eq 0 ]; then
  # The mkt parameter determines which Bing market you would like to
  # obtain your images from.

  mkt="zh-CN"
  # Try and guess language
  ML=$(echo $LANG | cut -f 1 -d .)
  case $ML in
	'en-US')
	mkt="en-US"
	;;
	'zh-CN')
	mkt="zh-CN"
	;;
	'ja-JP')
	mkt="ja-JP"
	;;
	'en-AU')
	mkt="en-AU"
	;;
	'en-UK')
	mkt="en-UK"
	;;
	'de-CH')
	mkt="de-DE"
	;;
	'de-DE')
	mkt="de-DE"
	;;
	'en-NZ')
	mkt="en-NZ"
	;;
	'en-CA')
	mkt="en-CA"
	;;
  esac
  exitAfterRunning=false

elif [ $# -eq 2 ]; then
  list='de-DE en-AU en-CA en-NZ en-UK en-US ja-JP zh-CN'
  # Valid values are:
  firstpar=$(sanity "$1")
  #inhibit code injection
  firstpar=$(echo "$firstpar" | sed s/[^a-zA-Z-]// )
  if [ "$(contains $list $firstpar)" = "y" ]; then
    mkt=$firstpar
  else
    echo "mkt must be one of the following:"
    printf '%s\n' "$list"
    exit 1
  fi

  secondpar=$(sanity "$2")
  if [ "$secondpar" = true ]; then
    exitAfterRunning=true
  else
    exitAfterRunning=false
  fi

else
  echo "Usage: `basename $0` mkt[de-DE, en-AU, en-CA, en-NZ, en-UK, en-US, ja-JP, zh-CN] exitAfterRunning[true,false]"
  echo "       Note that market and runonce must be specified together or not at all."
  exit 1
fi

# set target filename
tfn=$(ctfn)

DE=$(detectDE)

# Download the highest resolution

while true; do

    picName=""
    picURL=""
    
    for picRes in _1920x1200 _1920x1080 _1366x768 _1280x720 _1024x768; do

	# $xmlURL is needed to get the xml data from which
	# the relative URL for the Bing pic of the day is extracted
	xmlURL="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=$idx&n=1&mkt=$mkt"

	# Extract the relative URL of the Bing pic of the day from
	# the XML data retrieved from xmlURL, form the fully qualified
	# URL for the pic of the day, and store it in $picURL
	picURL=$bing$(echo $(curl -H "Content-Type: text/html; charset=UTF-8" -L -s $xmlURL) | egrep -o "<url>(.*)</url>" | cut -d ">" -f 2 | cut -d "<" -f 1)
	picURL=$(sanity "$picURL")

	curl -H "Content-Type: text/html; charset=UTF-8" -s -o "$tfn" -L "$picURL"
	downloadResult=$?
	if [ $downloadResult -ge 1 ]; then
		rm -f "$tfn"
		picURL=$bing$(echo $(curl -H "Content-Type: text/html; charset=UTF-8" -L -s $xmlURL) | egrep -o "<urlBase>(.*)</urlBase>" | cut -d ">" -f 2 | cut -d "<" -f 1)$picRes$picExt
		picURL=$(sanity "$picURL")
		# Download the Bing pic of the day
		curl -H "Content-Type: text/html; charset=UTF-8" -s -o "$tfn" -L "$picURL"

		# Test if download was successful.
		downloadResult=$?
		if [ $downloadResult -ge 1 ]; then
			rm -f "$tfn" && continue
		elif [ ! -s "$tfn" ]; then
			rm -f "$tfn" && continue   
		fi
	fi

	# Test if it's a pic
	file -L --mime-type -b "$tfn" | grep "^image/" > /dev/null
	picStatus=$?
	if [ $picStatus -ge 1 ]; then
		rm -f "$tfn" && continue
	fi

	if [ -x "/usr/bin/convert" -a -x "/usr/bin/mogrify" ]; then
		title=$(echo $(curl -H "Content-Type: text/html; charset=UTF-8" -L -s $xmlURL) | egrep -o "<copyright>(.*)</copyright>" | cut -d ">" -f 2 | cut -d "<" -f 1 )
		title=$(sanity "$title")
		/usr/bin/convert "$tfn" -resize 1920x1200 "$tfn"
		
		grav="south"
		if [ "$DE" = "WM" -o "$DE" = "kde" ]; then
			grav="north"
		fi

		iswc=$(which wc)
		if [ -x $iswc ]; then
			isBitStream=$(/usr/bin/convert -list font | grep "Bitstream-Vera-Sans" | wc -l)
			isDejaVu=$(/usr/bin/convert -list font | grep "DejaVu-Sans" | wc -l)
			if [ $isBitStream -ge 1 ]; then
				/usr/bin/convert -background "#00000080" -fill white -gravity center -size 1024 -font "Bitstream-Vera-Sans" -pointsize 22 caption:"${title}" "$tfn" +swap -gravity "$grav" -composite "$tfn"
			elif [ $isDejaVu -ge 1 ]; then
				/usr/bin/convert -background "#00000080" -fill white -gravity center -size 1024 -font "DejaVu-Sans" -pointsize 22 caption:"${title}" "$tfn" +swap -gravity "$grav" -composite "$tfn"
			fi
		fi
	fi
	# Test if it's still a pic
	file -L --mime-type -b "$tfn" | grep "^image/" > /dev/null && break

	rm -f "$tfn"
    done

    file -L --mime-type -b "$tfn" | grep "^image/" > /dev/null
    picStatus=$?
    if [ $downloadResult -ge 1 -o $picStatus -ge 1 ]; then
          echo "Failed to download any picture."
	  echo "Try again in 60 seconds."
          sleep 60
          continue
    else
	  doof
    fi

    if [ "$DE" = "cinnamon" ]; then
          # Set the Cinnamon wallpaper
          DISPLAY=:0 GSETTINGS_BACKEND=dconf gsettings set org.cinnamon.desktop.background picture-uri '"file://'$tfn'"'

          # Set the Cinnamon wallpaper picture options
          DISPLAY=:0 GSETTINGS_BACKEND=dconf gsettings set org.cinnamon.desktop.background picture-options $picOpts
    elif [ "$DE" = "gnome" ]; then
	checkdep "gconftool"
	# Set the GNOME 2 wallpaper
	gconftool-2 -s -t string /desktop/gnome/background/picture_filename "$tfn"
	
	# Set the GNOME 2 wallpaper picture options
	gconftool-2 -s -t string /desktop/gnome/background/picture_options "$picOpts"
    elif [ "$DE" = "gnome3" ]; then
	checkdep "gsettings"
	# export DBUS_SESSION_BUS_ADDRESS environment variable
	PID1=$(pgrep gnome-session)
	for PID in $PID1
	do
		if [ -r "/proc/$PID/environ" ]; then
		export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)
		fi
	done
	# Set the GNOME3 wallpaper	
	gsettings set org.gnome.desktop.background picture-options $picOpts
	gsettings set org.gnome.desktop.background picture-uri '"file://'$tfn'"'
    elif [ "$DE" = "kde" ]; then

	qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string:
var Desktops = desktops();                                                                                                                       
for (i=0;i<Desktops.length;i++) {
d = Desktops[i];
d.wallpaperPlugin = "org.kde.image";
d.currentConfigGroup = Array("Wallpaper","org.kde.image","General");
d.writeConfig("Image", "'$tfn'");
}'


    elif [ "$DE" = "lxde" ]; then
      checkdep "pcmanfm"
      pcmanfm -w "$tfn"
      pcmanfm --wallpaper-mode=center
      pcmanfm --wallpaper-mode=stretch
    elif [ "$DE" = "lxqt" ]; then
      checkdep "pcmanfm-qt"
      pcmanfm-qt -w "$tfn"
      pcmanfm-qt --wallpaper-mode=zoom
    elif [ "$DE" = "mac" ]; then
	# set target filename 4 mac
	tfnnew=$(ctfn)
	
	mv $tfn $tfnnew
	rm -f $tfnold

	osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'"$tfnnew"'"'
	osafirstResult=$?
	osascript -e 'tell application "System Events" to set picture of every desktop to "'"$tfnnew"'"'
	osasecondResult=$?
	sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '$tfnnew'" 2>&1 >/dev/null
	sqliteResult=$?

	tfnold=$tfnnew
    elif [ "$DE" = "mate" ]; then
      checkdep "dconf"
      dconf write /org/mate/desktop/background/picture-filename '"'$tfn'"'
    elif [ "$DE" = "xfce" ]; then
	checkdep "xfconf-query"
	# set to every monitor that contains image-path/last-image
	properties=$(xfconf-query -c xfce4-desktop -p /backdrop -l | grep -e "screen.*/monitor.*image-path$" -e "screen.*/monitor.*/last-image$")

	for property in $properties; do
		xfconf-query -c xfce4-desktop -p $property -s "$tfn"
	done
     elif [ $DE = "WM" ]; then
	checkdep "feh"
	feh --bg-fill --no-fehbg "$tfn"
    fi

    if [ "$exitAfterRunning" = true ] ; then
      # Exit the script
      exit 0
    fi

    # sleep for half a day
    DIFF_TIME=0
    LAST_RUN=$(date +%s)
    LAST_DAY=$(date +%A)
    LAST_HOUR=$(date +%I)
    while [ $DIFF_TIME -lt 43199 ]; do
	NOW=$(date +%s)
	DIFF_TIME=$(expr $NOW - $LAST_RUN)
	sleep 60
    done
done 

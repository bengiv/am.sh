#!/bin/sh
init=1
while :
do
	vol=$(osascript -e 'get volume settings')
	duration=$(osascript -e 'tell application "Music" to get {player position} & {duration} of current track')
	arr=(`echo ${duration}`)
	 curr=$(cut -d . -f 1 <<< ${arr[-2]})
	 diff=$(( end - curr ))
	 bar=$(spark 0 $diff ${arr[-1]})
	 currMin=$(echo $(( curr / 60 )))
	 currSec=$(echo $(( curr % 60 )))
if [ ${#currMin} = 1 ]
then
	currMin="0$currMin"
fi
if [ ${#currSec} = 1 ]
then
	currSec="0$currSec"
fi
if (( curr < 2 || init == 1 )); then
	init=0
	name=$(osascript -e 'tell application "Music" to get name of current track')
	name=${name:0:50}
	artist=$(osascript -e 'tell application "Music" to get artist of current track')
	artist=${artist:0:50}
	record=$(osascript -e 'tell application "Music" to get album of current track')
	record=${record:0:50}
	end=$(cut -d . -f 1 <<< ${arr[-1]})
	endMin=$(echo $(( end / 60 )))
	endSec=$(echo $(( end % 60 )))
	if [ ${#endMin} = 1 ]
	then
  		endMin="0$endMin"
	fi
	if [ ${#endSec} = 1 ]
	then
  		endSec="0$endSec"
	fi
	rm ~/Library/Scripts/tmp*
	osascript ~/Library/Scripts/album-art.applescript
	if [ -f ~/Library/Scripts/tmp.png ]; then
  		art=$(clear; viu ~/Library/Scripts/tmp.png -w 39 -h 13)
	else 
  		art=$(clear; viu ~/Library/Scripts/tmp.jpg -w 39 -h 13)
	fi
fi
vol=$(echo $(( $(awk -F ':|,' '{print $2}' <<< $vol) / 12)))
if [ $vol = 0 ]; then
	volIcon=🔇
else
	volIcon=🔊
fi
volBars='▁▂▃▄▅▆▇█'
volBG=${volBars:$vol:-1}
vol=${volBars:0:$vol}
paste <(printf %s "$art") <(printf %s "") <(printf %s "") <(printf %s "") <(printf %s "") <(printf '%s\n' "$name" "$artist - $record" "$(echo $currMin:$currSec ⎮'\e[00;36m'${bar:1:1}''${bar:1:1}'\033[0m'⎮ $endMin:$endSec)" "$volIcon $(echo "\e[0;32m$vol\033[0m$volBG")")
sleep 1
done

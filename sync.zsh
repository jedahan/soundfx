#!/usr/bin/env zsh

# hostnames
composing_station=DS-SoundFXStations-1.local
super_looper=DS-SoundFXStations-2.local
dj_station=DS-SoundFXStations-3.local


# dj station
if [[ $HOST = $dj_station ]]; then
  cd "$HOME/Desktop/DJ Station/DJBin"
  # remove any file except the 20 latest
  for file in *(om[21,-1]); do rm "$file"; done
  log=somefile.txt
  [[ -f $log ]] && rm $log
  touch $log
  i=0
  for file in *(om[1,20]); do
    rsync -a --rsh='ssh -p23731' $file $composing_station:$HOME/Desktop/Composer/Bin
    echo $i,"$file" >> $log
    i=$(( i + 1 ))
  done
else
  [[ $HOST = $composing_station ]] && prefix="Composer" && dirs=(MicRec KeyRec)
  [[ $HOST = $super_looper ]] && prefix="Super Looper" && dirs=(LoopRec)

  for dir in $dirs; do
    for file in "$HOME/Desktop/$prefix/$dir"/*(om[1,20]); do
      rsync -a --rsh='ssh -p23733' -- "$file" $dj_station:"$HOME/Desktop/DJ\ Station/DJBin"
    done
  done
fi

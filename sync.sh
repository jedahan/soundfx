#!/usr/bin/env zsh

# hostnames
composing_station=DS-SoundFXStations-1.local
super_looper=DS-SoundFXStations-2.local
dj_station=DS-SoundFXStations-3.local

$DEBUG && debug=echo

dj_prefix=$HOME/Desktop/DJ\ Station/DJBin

# dj station
if [[ $HOST = $dj_station ]]; then
  # remove any file except the 20 latest
  for file in *(om[21,-1]); do rm "$file"; done
  log=$dj_prefix/somefile.txt
  [[ -f $log ]] && rm $log
  touch $log
  i=0
  for file in $dj_prefix/*(om[1,20]); do
    echo $i,"$file" >> $log
    i=$(( i + 1 ))
  done
else
  [[ $HOST = $composing_station ]] && prefix="Composer" && dirs=(MicRec KeyRec)
  [[ $HOST = $super_looper ]] && prefix="Super\ Looper" && dirs=(LoopRec)

  for dir in $dirs; do
    $debug rsync -a -- $HOME/Desktop/$prefix/$dir/*(om[1,20]) $dj_station:$dj_prefix
  done
fi

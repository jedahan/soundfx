#!/usr/bin/env zsh

# hostnames
composing_station=DS-SoundFXStations-1.local # (wifi: 10.0.0.49  , ethernet: 169.254.100.232)
super_looper=DS-SoundFXStations-2.local      # (wifi: 10.0.0.202 , ethernet: 169.254.8.27)
dj_station=DS-SoundFXStations-3.local        # (wifi: 10.0.0.34  , ethernet: 169.254.56.100)

remote=$dj_station
log=transfer.log.txt

$DEBUG && debug=echo && prefix="$HOME" && dirs=(test)

# hostnames
[[ `hostname` = $composing_station ]] && prefix="$HOME/Desktop/Composer" && dirs=(MicRec KeyRec Bin)
[[ `hostname` = $super_looper ]] && prefix="$HOME/Desktop/Super\ Looper" && dirs=(LoopRec)

for remote_dir in $dirs; do
  i=0
  [[ -f $log ]] && rm $log
  touch $log
  for file in $prefix/$remote_dir/*(om[1,20]); do
    echo $i,"$file" >> $prefix/$remote_dir/$log
    $debug rsync -a -- $file $remote:$prefix/$remote_dir/
    i=$(( i + 1 ))
  done
  $debug rsync -a -- $log $remote:$prefix/$remote_dir/
done

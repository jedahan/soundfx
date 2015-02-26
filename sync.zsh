#!/usr/bin/env zsh

# hostnames
composing_station=DS-SoundFXStations-1.local
super_looper=DS-SoundFXStations-2.local
dj_station=DS-SoundFXStations-3.local

desktop="/Users/doseum/Desktop"

function createLogFile {
  rm somefile.txt
  log=/var/tmp/somefile.txt
  [[ -f $log ]] && rm $log
  touch $log
  i=0
  for file in *(om[1,20]); do
    echo $i,"$PWD/$file" >> $log
    i=$(( i + 1 ))
  done
  mv $log .
}

function synceverything {
  if [[ $HOST = $composing_station ]]; then
    cd $desktop/Composer/Bin
    rm -rf *
    cp ../MicRec/*(om[1,20]) .
    createLogFile

    dirs=(MicRec KeyRec)
    for dir in $dirs; do
      for file in $desktop/Composer/$dir/*(om[1,20]); do
        rsync -a --rsh='ssh -p23733' -- "$file" $dj_station:$desktop/DJStation/DJBin
      done
    done
  fi

  if [[ $HOST = $super_looper ]]; then
   # sync directories to djstation
    dirs=(LoopRec)
    for dir in $dirs; do
      for file in $desktop/SuperLooper/$dir/*(om[1,20]); do
        rsync -a --rsh='ssh -p23733' -- "$file" $dj_station:$desktop/DJStation/DJBin
      done
    done
  fi

  if [[ $HOST = $dj_station ]]; then
    cd $desktop/DJStation/DJBin
    for file in *(om[21,-1]); do rm "$file"; done
    createLogFile
  fi
}

# do this 5 times a minute
for i in {1..5}; do
  synceverything
  sleep 10
done

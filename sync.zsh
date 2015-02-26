#!/usr/bin/env zsh

# hostnames
composing_station=DS-SoundFXStations-1.local
super_looper=DS-SoundFXStations-2.local
dj_station=DS-SoundFXStations-3.local

desktop="/Users/doseum/Desktop"

function createLogFile() {
  log=/var/tmp/somefile.txt
  [[ -f $log ]] && rm $log
  touch $log
  i=0
  for file in *(om[1,20]); do
    echo $i,"$file" >> $log
    i=$(( i + 1 ))
  done
  mv $log .
}

function synceverything() {
  if [[ $HOST = $dj_station ]]; then
    # remove all files except the 20 latest
    cd $desktop/DJStation/DJBin
    for file in *(om[21,-1]); do rm "$file"; done
    createLogFile()
  fi


  if [[ $HOST = $composing_station ]]; then
    # copy the latest 20 files from MicRec
    cd $desktop/Composer/Bin
    rm -rf *
    cp ../MicRec/*(om[1,20]) .
    createLogFile()

    # sync directories to djstation
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
}

# do this 5 times a minute
synceverything()
sleep 10
synceverything()
sleep 10
synceverything()
sleep 10
synceverything()
sleep 10
synceverything()

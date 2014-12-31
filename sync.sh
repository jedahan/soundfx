#!env zsh

directory=/home/micro/work/soundfx/Composer
remote=10.0.0.3
log=transfer.log.txt
$DEBUG && debug=echo

[[ `hostname` = 'macro' ]] && dirs=(MicRec KeyRec Bin) || dirs=(LoopRec)
for remote_dir in $dirs; do
  i=0
  rm $log > /dev/null
  touch $log
  for file in $directory/$remote_dir/*(om[1,20]); do
    $debug rsync -a -- $micrec $remote:$directory/$remote_dir/
    $debug echo $i,"$file" >> $log
    i=$(( i + 1 ))
  done
  $debug rsync -a -- $log $remote:$directory/$remote_dir/
done

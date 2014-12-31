#!env zsh

directory=/Users/testuser/Desktop/Composer/
remote=10.0.0.3
log=transfer.log.txt
[[ -z $DEBUG ]] && debug=echo

[[ `hostname` = 'macro' ]] && dirs='LoopRec' || dirs='MicRec KeyRec Bin' 
for remote_dir in $dirs
  i=0
  rm $log; touch $log
  for file in $directory/$remote_dir/*(om[1,20]).
    $debug rsync -a -- $micrec $remote:$directory/$remote_dir/
    $debug echo $i,"$file" >> $log
    i=(( i++ ))
  end
  $debug rsync -a -- $log $remote:$directory/$remote_dir/
end

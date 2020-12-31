#!/usr/bin/sh
source_path=/sync_sources
backup_path=/sync_sources_bk
target_path=/backup_source
log_path=/sync_logs
IP_HOST=192.168.9.29
user=root

#Create backup source and log folder if it noe exist

if [[ ! -d $backup_path ]];then
mkdir -p $backup_path
fi

if [[ ! -d $log_path ]];then
mkdir -p $log_path
fi

#Create dynamic execution command for sftp
>$backup_path/commands.lst
echo "cd $target_path" >> $backup_path/commands.lst
echo "Start sync job at $(date +"%H:%M") with files below: " >>$log_path/sync_job_$(date +"%d_%m_%y").log
cd $source_path
for i in `find . -type f`
  do
        echo "put $i" >> $backup_path/commands.lst
        echo -e "-\t$i" >> $log_path/sync_job_$(date +"%d_%m_%y").log
  done


sftp -b $backup_path/commands.lst $user@$IP_HOST:$target_path

result=$?
echo "Snc Job Result: $result"
if [[ $result -eq 0 ]];then
        echo "Result: Sync Job Successfull|||||||" >> $log_path/sync_job_$(date +"%d_%m_%y").log
else
        echo "Rusult: Sync Job Error|||||||||" >> $log_path/sync_job_$(date +"%d_%m_%y").log

echo -e "--------------------------------------------------------------------\n">>$log_path/sync_job_$(date +"%d_%m_%y").log
fi

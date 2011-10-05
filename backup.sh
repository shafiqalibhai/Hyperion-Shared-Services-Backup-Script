#Set the Shared Services Home 

SHARED_SERVICES_HOME=/hyperionapp01/Hyperion/SharedServices/9.3.1

#Gets the backup folder location as a command line argument

ARGNO=1

#DESTINATION=$1/`date +%Y%m%e`
DESTINATION=$1

if [ $# -lt "$ARGNO" ]; then

echo "ERROR: You must enter a backup folder full path immediately after batch file name"

echo

echo "USAGE: backhp.sh backup_folder"

exit 1

else 

sh $SHARED_SERVICES_HOME/server/scripts/hss_backup.sh $DESTINATION $SHARED_SERVICES_HOME | tee log.file

sh $SHARED_SERVICES_HOME/server/scripts/runDBArchiveData.sh $DESTINATION $SHARED_SERVICES_HOME | tee -a log.file

#archive $DESTINATION directory
tar -cf "part1."`date +%Y%m%e`".tar" $DESTINATION

#scp archive to other server /backup directory
scp "part1."`date +%Y%m%e`".tar" hyperion@10.50.2.254:/backup

#delete archive and directory
rm "part1."`date +%Y%m%e`".tar"

#archive /export/home/hyperion/
tar -cf "part2."`date +%Y%m%e`".tar" /export/home/hyperion/

#scp archive to other server /backup directory
scp "part2."`date +%Y%m%e`".tar" hyperion@10.50.2.254:/backup

#delete arcive
rm "part2."`date +%Y%m%e`".tar"

mail -s "Hyperion Backup" email@shafiq.in<log.file

#rm log.file

fi

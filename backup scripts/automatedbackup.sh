#! /bin/bash
# Attempts to backup a set of folders using rsync to a networked Synology DS216j NAS.
# The Synology NAS runs an rsync server.
# Mark E. Taylor
# Created: 22/08/2016
# Last updated: 06/02/2020
#
# Released under MIT open source licence.
#
# The number of days to keep files, older files will be deleted. Based on created time (ctime).
DAYS=5
# The MAC address of the local Synology NAS.
WOLANMAC=YOUR NAS MAC ADDRESS HERE
#
# The default delay to wait for the NAS to wake up. If a command line argument is supplied then wait for that number seconds. Useful during testing, e.g. a2.sh 3, will wait for only 3 seconds.
DELAY=30
if [ "$#" -eq 1 ]
then
	if [ "$1" -gt 0 ]
	then
	DELAY=$1
	fi
fi
#
echo "************* Starting the backup *************"
echo
echo "The date and the time of the backup is:" `date`
echo
# Get the epoch time that the script started. Used to work out how long the script ran for.
start_time=`date +%s`
#
# Delete MySQL backup files older than $DAYS days.
echo "Deleting MySQL backup files older than $DAYS days (using ctime)..."
echo "Deleting compressed MySQL backup files matching the pattern fast*_mysql*.gz..."
find /home/mark/mysql_backups/fast*_mysql*.gz -type f -ctime +$DAYS -printf "File dated %AA %Ax named '%f' will be deleted.\n" -exec rm {} \;
echo "Deleting MySQL dump files matching the pattern *.sql..."
find /home/mark/mysql_backups/*.sql -type f -mtime +$DAYS -printf "File dated %AA %Ax named '%f' will be deleted.\n" -exec rm {} \;
echo
#
# Now wakeup the Synology DS216j NAS.
echo "Waking up the Synology DiskStation DS216j..."
wakeonlan $WOLANMAC
# Wait $DELAY seconds for the Synology NAS to wake up.
echo "Waiting for $DELAY seconds for the Synology NAS to wake up..."
sleep $DELAY
echo
#
# Now rsync some folders to the Synology DS216j NAS.
# Using the rsync server service on the Synology DS216j.
echo "Now rsynch'ing the folders weather, bin, mysql_backups and WWW to the Synology DS216j NAS..."
#
# Weather data files.
echo "Now synching weather files..."
rsync -r -t -v --password-file=/home/mark/bin/rspw.txt \
--delete-after \
/home/mark/weather rsync://rsyncserver@synology/homes/rsyncserver
if [ $? -eq 0 ]
then
        RS2="\e[32msucessful\e[39m"
else
        RS2="\e[31mfailed\e[39m"
fi
#RS2=$?
LN2=$LINENO
#
# Local user bin files. *** Exclude the NAS password file! ***
echo
echo "Now synching user bin files (excluding the NAS rsync user password file)..."
rsync -r -t -v --password-file=/home/mark/bin/rspw.txt \
--exclude-from=/home/mark/bin/rsexclude.txt --delete-after --delete-excluded \
/home/mark/bin rsync://rsyncserver@synology/homes/rsyncserver
if [ $? -eq 0 ]
then
	RS3="\e[32msucessful\e[39m"
else
	RS3="\e[31mfailed\e[39m"
fi
#RS3=$?
LN3=$LINENO
#
# Local mysql_backups files.
echo
echo "Now synching mysql backup files..."
rsync -r -t -v --password-file=/home/mark/bin/rspw.txt \
--delete-after \
/home/mark/mysql_backups rsync://rsyncserver@synology/homes/rsyncserver
if [ $? -eq 0 ]
then
        RS4="\e[32msucessful\e[39m"
else
        RS4="\e[31mfailed\e[39m"
fi
#RS4=$?
LN4=$LINENO
echo
#
# Local /var/www files.
echo
echo "Now synching /var/www files..."
rsync -r -t -v --password-file=/home/mark/bin/rspw.txt \
--delete-after \
/var/www rsync://rsyncserver@synology/homes/rsyncserver
if [ $? -eq 0 ]
then
        RS5="\e[32msucessful\e[39m"
else
        RS5="\e[31mfailed\e[39m"
fi
#RS5=$?
LN5=$LINENO
echo
#
echo -e "All done, result codes for all rsync tasks: 'weather' $RS2 at line $LN2, 'bin' $RS3 at line $LN3, 'mysql' $RS4 at line $LN4 '/var/www' $RS5 at line $LN5."
echo "The backup of the home 'bin' folder, 'weather', 'mysql_backups' data and '/var/www' is now complete at:" `date`"."
#
# Caputure the end epoch time when the script finished. Used to calculate how long the script took to run in seconds.
end_time=`date +%s`
run_time=$((end_time-start_time))
echo
echo "This backup took $run_time seconds to complete."
echo "***********************************************"
echo

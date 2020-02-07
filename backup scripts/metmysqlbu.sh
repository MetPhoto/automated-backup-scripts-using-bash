#!/bin/bash
# Backs up all the local MySQL databases to a folder, which in turn is backed up to a local NAS.
# Script improved after reading this http://dev.mysql.com/doc/mysql-enterprise-backup/3.6/en/mysqlbackup.privileges.html
# Created: 01/11/2017
# Last updated: 06/02/2020
#
# Released under MIT open source licence.
#
cd /home/name
echo -e "Backing up \e[31mMySQL\e[39m databases on:" `date`
DATESTAMP=$(date +%d%m%Y)
TIMESTAMP=$(date +%H%M%P)
HOSTNAME=$(uname -n)
umask 001
TEMP_FILENAME=${HOSTNAME}_uncompressed_my_sql_backup_${DATESTAMP}_${TIMESTAMP}.sql
mysqldump -h localhost --all-databases --lock-all-tables --skip-events --user=backup --password=readonly >> /home/mark/mysql_backups/$TEMP_FILENAME
umask 001
echo
echo -e "Compressing the \e[31mMySQL\e[39m backup..."
FILENAME=${HOSTNAME}_mysql_backup_${DATESTAMP}_${TIMESTAMP}.gz
gzip -cr /home/mark/mysql_backups/$TEMP_FILENAME  >> /home/mark/mysql_backups/$FILENAME
echo
echo -e "\e[34mAll done."
echo

# Simple bash scripts to backup data from a Linux server to a Synology NAS
## Written by Mark Taylor

This code is provided "as is" without any warranty. It is provided for educational purposes only. See MIT license.

Mark Taylor - February 2020.

## Background
A simple set of scripts that backup various folders on a local Raspberry Pi server.

## The challenge
Make my amateur code better. Tell me how to make it 'better', more secure, more efficient and easy to update & maintain.

I am sure it can be improved.

## Functionality
Each script is run as cron job at a set time.

`metmysqlbu.sh` is run first. This creates a MySQL dump file and a corresponding gzip compressed version.

`raspy.txt` contains the password for the RSYNC account used on the Synology NAS. This file is excluded from the backup.

`automatedbackup.sh` is called after `metmysqlbu.sh`. This script backs up four folders in my case. However, any number of files or folders could be backed up.  In this instance I backup, my account local `bin` folder, the data from my local weather station (`weather`), `mysql_backups` (files created in step one above) and all of my web files `/var/www/*`.

The RSYNC process is set to overwrite files.

The automated backup script will automatically delete MySQL backups older than 5 days. The number of days can be set in the script.

## Dependancies
A wake-on-lan utility is used on the Raspberry Pi to 'wake up' the NAS, as it maybe in power saving sleep mode.

RSYNC installed and configured on the Synology NAS.

## Optional level of paranoia
I have the Synology NAS backup the files from the RSYNC folder to Dropbox. To ensure that the data is off-site, i.e. not at home.

## Known issues
Very little error checking in the code.

## System requirements
I run this code on a Raspberry Pi 3.
- Linux - 4.9.35-v7+ #1014 SMP (Raspbian / Debian)
- MySQL - Ver 14.14 Distrib 5.5.62, for debian-linux-gnu (armv8l) using readline 6.3

## Notes
Any reference in the code to `fastpi` is a reference to the host the code is installed on. My local Raspberry Pi 3.
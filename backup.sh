#!/bin/bash
nowdate=$(date +%d-%b-%H_%M)
echo "creating backup..."
tar -czf /root/backup/wp-backup-${nowdate}.tar.gz -C /var/www/mydomain.com/wordpress/ .

mysqldump wordpress > /root/backup/wordpress-${nowdate}.sql && echo "backup created"
echo "uploading to s3"
aws s3 cp /root/backup/wp-backup-${nowdate}.tar.gz s3://my-tt23-test-bucket/wordpress_files/ || echo "upload failed"
aws s3 cp /root/backup/wordpress-${nowdate}.sql s3://my-tt23-test-bucket/wordpress_dbs/ || echo "upload failed" 
echo "upload completed"

# create database if not exists 
mysql -h myrdsinstance.cj8rboipihui.us-east-1.rds.amazonaws.com -u myrdsuser -e "CREATE DATABASE IF NOT EXISTS wordpress";


#restore the remote rds db with latest database backup
mysql -h myrdsinstance.cj8rboipihui.us-east-1.rds.amazonaws.com  wordpress < /root/backup/wordpress-${nowdate}.sql


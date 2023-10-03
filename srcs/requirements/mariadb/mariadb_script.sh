#!/bin/bash

if [ -d "/var/lib/mysql/$DB_NAME" ]; then
	echo "DB is already configured"
else
	echo "Start DB configuration"
	touch /var/lib/mysql/config_db.sql
	touch /var/lib/mysql/change_root.sql
	chmod 755 /var/lib/mysql/config_db.sql
	chmod 755 /var/lib/mysql/change_root.sql
	#mysql_upgrade 2> /dev/null

# Create db, give privileges to root across all databases on the server from localhost,
# Create a user and give privileges on DB_NAME from any host (remote, local...)
# Flush privileges to update modif
	cat << _EOF_ > /var/lib/mysql/config_db.sql
CREATE DATABASE $DB_NAME;
FLUSH PRIVILEGES;
CREATE USER '$DB_ADMIN'@'%' IDENTIFIED BY '$DB_ADMIN_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_ADMIN'@'%';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
_EOF_

	cat << _EOF_ > /var/lib/mysql/change_root.sql
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
_EOF_



# give the sql file to conf the server

	service mariadb start
	#sleep 1
	mariadb -u root < /var/lib/mysql/config_db.sql 
	sleep 1
	mariadb -u root < /var/lib/mysql/change_root.sql
	#sleep 2  
	mariadb-admin -u root -p$DB_ROOT_PASSWORD shutdown
	echo "restarting server"
	#sleep 1

fi

exec mariadbd 2>/dev/null

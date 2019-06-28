#!/bin/bash

echo "Update packages and install PostgreSQL"
sudo apt-get update
sudo apt-get install -y postgresql
sudo apt-get install -y postgresql-client
sudo apt-get install -y postgresql-contrib

echo "Update PostgreSQL configuration"
sudo rm -rf /etc/postgresql/9.5/main/postgresql.conf
sudo cp /tmp/configs/postgresql.conf /etc/postgresql/9.5/main/postgresql.conf

echo "Setup replication"
sudo systemctl stop postgresql
  sudo mv ../../var/lib/postgresql/9.5/main ../../var/lib/postgresql/9.5/main_old
sudo -u postgres pg_basebackup -h 10.132.0.76 -D /var/lib/postgresql/9.5/main -U replica -v -xlog-method=stream
sudo cp /tmp/configs/recovery.conf /var/lib/postgresql/9.5/main/recovery.conf
sudo systemctl start postgresql

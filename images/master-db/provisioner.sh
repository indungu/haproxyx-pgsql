#!/bin/bash

echo "Setup the environment"
sudo apt-get update
sudo apt-get install -y postgresql
sudo apt-get install -y postgresql-client
sudo apt-get install -y postgresql-contrib

echo "Create replication user"
sudo -u postgres psql -c "CREATE USER replica REPLICATION LOGIN ENCRYPTED PASSWORD 'pgsqlreplicationuserpass';"

echo "Update PostgreSQL configuration"
sudo rm -rf /etc/postgresql/9.5/main/postgresql.conf
sudo rm -rf /etc/postgresql/9.5/main/pg_hba.conf
sudo cp /tmp/configs/postgresql.conf /etc/postgresql/9.5/main/postgresql.conf
sudo cp /tmp/configs/pg_hba.conf /etc/postgresql/9.5/main/pg_hba.conf

echo "Create PostgreSQL archive folder and restart postgresql service"
sudo mkdir -p /var/lib/postgresql/9.5/main/archived
sudo systemctl restart postgresql

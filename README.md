# haproxyx-pgsql
A project for deploying a Highly Available PostgreSQL Master-Slave replication setup with HAProxy.

## Prerequisites
You will need the following installed in your system to enable a quick setup.

* [Packer]()
* [Make]()
* [Terraform]()

## Setup
I have included an automation script for setting up this Master-Slave Database architecture.

To set it up just run the following command

```bash
$ PROJECT_ID="<google_project_id>" bash auto_deploy.sh
```

rdmo-ansible
============

This repo contains an ansible playbook to deploy an instance of
[RDMO](https://rdmorganiser.github.io) using PostgresSQL, Gunicorn and NGINX.

The playbook performs the following steps:

* Install distribution packages
* Create rdmo user
* Configure NGINX reverse proxy and obtain certificate using certbot
* Configure Systemd service
* Create PostgreSQL user and database
* Clone rdmo-app
* Install RDMO and dependencies in a virtual environment
* Create a basic `config/settings/local.py` config file
* Initialize RDMO

Once the playbook has finished, RDMO should be available at the provided URL.

Setup
-----

Create a `hosts.yml` file with the hostname of your RDMO machine and other variables, e.g.:

```yml
all:
  hosts:
    rdmo.jochenklar.dev:
  vars:
    rdmo_app: rdmo
    rdmo_app_repo: https://github.com/rdmorganiser/rdmo-app
    rdmo_app_path: /srv/rdmo/rdmo-app
    rdmo_host: rdmo.jochenklar.dev
    rdmo_dist: rdmo[allauth,postgres,openapi,gunicorn]
    rdmo_user: rdmo
    rdmo_home: /srv/rdmo
    rdmo_venv: /srv/rdmo/rdmo-app/env

    django_secret_key: supersecretkey

    certbot_email: admin@jochenklar.de

    ansible_python_interpreter: auto_silent
```

Usage
-----

```bash
./play.sh
```

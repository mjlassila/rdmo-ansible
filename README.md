rdmo-ansible
============

This repo contains an ansible playbook to deploy one or more instances of
[RDMO](https://rdmorganiser.github.io) using PostgresSQL, Gunicorn and NGINX.

The playbook performs the following steps:

* Install distribution packages
* Create rdmo users
* Configure NGINX reverse proxies and obtain certificates using certbot
* Configure Systemd services
* Create PostgreSQL users and databases
* Clone rdmo-app repositories
* Install RDMO and dependencies in virtual environments
* Create basic `config/settings/local.py` config files
* Initialize RDMO sites

Once the playbook has finished, each RDMO site should be available at its
provided URL.

Setup
-----

Create a `hosts.yml` file with the hostname of your RDMO machine in either
the `rhel9` or `almalinux9` inventory group and other variables. The
`rdmo_sites` list can contain any number of sites:

```yml
rhel9:
  hosts:
    rdmo.example.org:
  vars:
    rdmo_app_repo: https://github.com/rdmorganiser/rdmo-app
    rdmo_dist: rdmo[allauth,postgres,openapi,gunicorn]
    rdmo_user: rdmo
    rdmo_home: /srv/rdmo
    rdmo_venv: /srv/rdmo/env
    rdmo_dbname: rdmo
    rdmo_multisite: true

    rdmo_sites:
      - host: rdmo-one.example.org
        service: rdmo-one
        app_path: /srv/rdmo/rdmo-one/rdmo-app
        site_id: 1
        django_secret_key: supersecretkey-one

      - host: rdmo-two.example.org
        service: rdmo-two
        app_path: /srv/rdmo/rdmo-two/rdmo-app
        site_id: 2
        django_secret_key: supersecretkey-two

    certbot_email: admin@example.org

    ansible_python_interpreter: auto_silent
```

Each site entry requires the following variables:

* `host`: public DNS name of the site.
* `service`: systemd service name and Gunicorn runtime/log directory name.
* `app_path`: checkout path for the site's `rdmo-app` repository.
* `site_id`: Django Sites framework ID for the site. Create additional site
  records in the RDMO admin interface and use their numeric IDs here.
* `django_secret_key`: Django secret key for the site.

The following site variables are optional and fall back to the global values
shown above:

* `app_repo`: defaults to `rdmo_app_repo`.
* `dist`: defaults to `rdmo_dist`.
* `user`: defaults to `rdmo_user`.
* `home`: defaults to `rdmo_home`.
* `venv`: defaults to `rdmo_venv`. Use this default to share one virtual
  environment across multiple RDMO app directories.
* `dbname`: defaults to `rdmo_dbname`. Multisite installations usually share
  one database across all sites.
* `multisite`: defaults to `rdmo_multisite` and controls `MULTISITE` in the
  rendered Django settings.

In a multisite installation, every site has its own `rdmo-app` directory and
`local.py`, while sites can share a common virtual environment and database. The
playbook therefore creates and installs each unique virtual environment only once
and reuses it for all sites that reference the same `venv` path.

For single-site installations, the playbook remains compatible with the legacy
variables:

```yml
almalinux9:
  hosts:
    rdmo.jochenklar.dev:
  vars:
    rdmo_app: rdmo
    rdmo_app_repo: https://github.com/rdmorganiser/rdmo-app
    rdmo_app_path: /srv/rdmo/rdmo-app
    rdmo_host: rdmo.jochenklar.dev
    rdmo_service: rdmo
    rdmo_dbname: rdmo
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

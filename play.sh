#!/bin/bash
ansible-playbook -i hosts.yml $@ main.yml

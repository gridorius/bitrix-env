#!/bin/bash

sudo chown bitrix:bitrix -R /home/bitrix;
sudo -u bitrix ./DirectoryWatcher sync ./www ./extensions &
sudo -u bitrix ./DirectoryWatcher watch ./www ./extensions &
apache2-foreground
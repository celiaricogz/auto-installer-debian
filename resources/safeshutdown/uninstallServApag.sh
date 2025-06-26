#!/bin/bash

systemctl stop servApag.service
systemctl disable servApag.service
rm /usr/bin/ServApag
rm /usr/bin/ServApag.cfg
rm /etc/systemd/system/servApag.service

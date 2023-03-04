#!/bin/bash
INSTALLPATH="/config/simple-edgeos-backup"
mkdir -p ${INSTALLPATH}

curl -o ${INSTALLPATH}/seosb.conf https://raw.githubusercontent.com/smford/simple-edgeos-backup/master/seosb.conf

curl -o ${INSTALLPATH}/seos-backup.sh https://raw.githubusercontent.com/smford/simple-edgeos-backup/master/seos-backup.sh
chmod 755 ${INSTALLPATH}/seos-backup.sh

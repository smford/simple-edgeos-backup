#!/usr/bin/ssh-agent bash
set -x
source /config/simple-edgeos-backup/seosb.conf

ssh-add ${SSH_KEYFILE}

# Pull commit info
COMMIT_VIA=${COMMIT_VIA:-other}
COMMIT_CMT=${COMMIT_COMMENT:-$DEFAULT_COMMIT_MESSAGE}

# If no comment, replace with default
if [ "$COMMIT_CMT" == "commit" ];
then
    COMMIT_CMT=$DEFAULT_COMMIT_MESSAGE
fi

# Check if rollback
if [ $# -eq 1 ] && [ $1 = "rollback" ];
then
    COMMIT_VIA="rollback/reboot"
fi

TIME=$(date +%Y-%m-%d" "%H:%M:%S)
USER=$(whoami)

GIT_COMMIT_MSG="$COMMIT_CMT | by $USER | via $COMMIT_VIA | $TIME"

# Remove temporary files
#echo "edgerouter-backup: Removing temporary files"
if [ -d "/tmp/simple-edgeos-backup" ];
then
    rm /tmp/simple-edgeos-backup/$FNAME_CONFIG  &> /dev/null
    rm /tmp/simple-edgeos-backup/$FNAME_CLI  &> /dev/null
    rm /tmp/simple-edgeos-backup/$FNAME_BACKUP.tar  &> /dev/null
else
    mkdir /tmp/simple-edgeos-backup
    git clone --depth 1 ${GITHUB_REPO} /tmp/simple-edgeos-backup
fi

# Generate temporary config files
sudo cli-shell-api showConfig --show-active-only --show-ignore-edit --show-show-defaults > /tmp/simple-edgeos-backup/$FNAME_CONFIG
sudo cli-shell-api showConfig --show-commands --show-active-only --show-ignore-edit --show-show-defaults > /tmp/simple-edgeos-backup/$FNAME_CLI
sudo find /config/* | grep -v "/config/dhcpd.leases" | grep -v "seosbackup.key" | xargs tar czvf /tmp/simple-edgeos-backup/$FNAME_BACKUP.tar.gz &> /dev/null

echo "simple-edgeos-backup: Triggering 'git commit'"
cd /tmp/simple-edgeos-backup
git config user.email "${GITHUB_EMAIL}"
git config user.name "${GITHUB_USER}"
git add $FNAME_CONFIG
git add $FNAME_CLI
git add $FNAME_BACKUP.tar.gz
git commit -m "$GIT_COMMIT_MSG"
git push

echo "simple-edgeos-backup: Complete"

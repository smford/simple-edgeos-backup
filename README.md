# simple-edgeos-backup

A simple tool to regularly backup Ubiquiti Edge Router Configuration to github

## Installation

1. SSH to your edge router
    ```
    configure
    apt-get update
    apt-get install git
    commit
    save
    exit
    ```
1. Install backup script
    ```
    curl https://raw.githubusercontent.com/smford/simple-edgeos-backup/master/install.sh | sudo bash
    ```
1. Configure SSH key
    ```
    ssh-keygen -t ed25519 -C "seosb-github-ssh-key" -f /config/simple-edgeos-backup/seosbackup.key
    ```
    ```
    chown 0600 /config/simple-edgeos-backup/seosbackup.key
    ```
1. Configure script
1. Configure github ssh access
   1. Accept github ssh host key check
   1. Add SSH public key in to github
1. Test
    ```
    /config/simple-edgeos-backup/seos-backup.sh --testgithub
    ```
1. Add as a regular task
    ```
    configure
    set system task-scheduler task seosbackup executable path /config/simple-edgeos-backup/seos-backup.sh
    set system task-scheduler task seosbackup interval 7d
    set system task-scheduler task seosbackup executable arguments '--backup'
    commit
    save
    exit
    ```

### Configuration File Options

## Restoring backups

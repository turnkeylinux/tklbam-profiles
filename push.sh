#!/bin/bash -e

HOST=root@iota
sync() {
    rsync $1 -avP --no-owner --no-group --progress \
        -e ssh builds/ $HOST:/volatile/tklbam/archives/
}

echo "Doing a dry run"
echo
sync --dry-run

read -p "Sync for real? [Y/n]" VAL
case "$VAL" in
    y|Y) sync ;;
    n|N) exit 3 ;;
esac


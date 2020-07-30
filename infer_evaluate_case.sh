#!/bin/bash -eu

if [ $# -lt 2 ]; then
    echo "usage: $0 (good|bad) path/to/bugs.txt"
    exit 1
fi

goodbad="$1"
alarms=$(wc -l "$2" | cut -d' ' -f1)

case $goodbad in
    "good")
        if [ "$alarms" -gt 1 ]; then
            echo "$2 ($goodbad): imprecise"
        else
            echo "$2 ($goodbad): ok"
        fi
        ;;
    "bad")
        if [ "$alarms" -lt 2 ]; then
            echo "$2 ($goodbad): false negative"
        else
            echo "$2 ($goodbad): ok"
        fi
        ;;
    *)
        echo "invalid '$goodbad': must be either 'good' or 'bad'."
        exit 1
esac


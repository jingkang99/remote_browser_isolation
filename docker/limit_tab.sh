#!/bin/bash

tabct=$(/opt/zeroadmin/chrome-tabct | wc -l)
if [[ $tabct > $((LIMIT_CHMTAB+2)) ]]; then
    echo "chrome tab opened: "${tabct}, allowed $LIMIT_CHMTAB
    pkill chrome
fi

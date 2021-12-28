#!/bin/bash

pkill chrome

# jq -r '.' /root/.config/chromium/Default/Preferences | grep exit
# remove max/min windows buttons
cp /root/.config/chromium/Default/Preferences 1
jq -r '.browser.custom_chrome_frame     |= false' 1 > 2 && cp 2 1
jq -r '.bookmark_bar.show_on_all_tabs   |= false' 1 > 2 && cp 2 1
jq -r '.bookmark_bar.show_reading_list  |= false' 1 > 2 && cp 2 1
jq -r '.bookmark_bar.show_apps_shortcut |= false' 1 > 2 && cp 2 1
jq -r '.profile.exit_type |= "None"'              1 > 2 && cp 2 1
cp 1 /root/.config/chromium/Default/Preferences
rm -rf 1 2

. /etc/bash.bashrc

/usr/bin/chromium --no-sandbox --window-position=0,0 --window-size=$CHMWIND_SIZE --disable-dev-shm-usage --disable-gpu \
  --disable-sync --disable-full-history-sync --disable-software-rasterizer --disable-plugins --no-report-upload --no-pings \
  --disable-plugins-discovery --disable-notifications --mute-audio --dns-prefetch-disable --remote-debugging-port=9222 \
  --disable-software-video-decoders --disable-print-preview --disable-breakpad --no-default-browser-check --noremote \
  --no-experiments --no-service-autorun --bwsi --no-first-run --lang=zh-CN --enable-low-end-device-mode --disable-infobars  \
  --renderer-process-limit=2 --disable-site-isolation-trials --disable-glsl-translator --disable-translate --noerrdialogs \
  --disable-device-orientation --disable-internal-flash --purge-memory-button --disable-seccomp-sandbox \
  --disable-session-crashed-bubble --disable-restore-session-state $CHROME_OPTNS $HOME_WEB_URL
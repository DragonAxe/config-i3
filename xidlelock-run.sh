#!/bin/bash

################################################################################
##                     DragonAxe xidlelock configuration                      ##
################################################################################

# Only exported variables can be used within the timer's command.
#export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

# Run xidlehook
~/.cargo/bin/xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  `# --not-when-audio` \
  `# Dim the screen after 60 seconds, undim if user becomes active` \
  --timer normal 540 \
    'expr `cat /sys/class/backlight/intel_backlight/brightness` > backup-backlight.txt; echo 10 | sudo tee /sys/class/backlight/intel_backlight/brightness' \
    'cat backup-backlight.txt | sudo tee /sys/class/backlight/intel_backlight/brightness' \
  `# Undim & lock after 9 more minutes` \
  --timer primary 60 \
    'cat backup-backlight.txt | sudo tee /sys/class/backlight/intel_backlight/brightness; gnome-screensaver-command -l' \
    '' \
  `# Finally, suspend an half hour after it locks` \
  --timer normal 1800 \
    'systemctl suspend' \
    ''

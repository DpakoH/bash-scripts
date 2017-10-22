#!/bin/bash

killPID () {
  NAME="$1"
  KILLPID=`ps axlw | grep "$NAME" | tr -s ' ' | head -n 1 | grep -v " grep " | cut -d' ' -f 3`
  if [ -z "$KILLPID" ]; then
    echo "$NAME PID not found"
  else
    echo "kill $KILLPID"
    kill $KILLPID
  fi
}


killPID "services.exe"
killPID "explorer.exe"
killPID "wineserver"
killPID "TurbineLauncher"
killPID "winedevice.exe"
killPID "plugplay.exe"

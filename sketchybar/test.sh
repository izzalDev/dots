#!/bin/bash

case "$1" in
  battery|power|system_woke) 
    echo "berhasil"
    ;;
  mouse.clicked)
    echo "mouse.clicked"
    ;;
  * )
    echo "gagal"
    ;;
esac

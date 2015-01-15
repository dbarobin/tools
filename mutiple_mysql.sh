#!/bin/bash
# Author: Robin Wen
# Date: 11:06 2015/01/15
# Func: Startup and Shutdown MySQL 5.1, 5.5 and 5.6.

# Start MySQL function
start() {
   sudo mysqld_multi start 5173 && sleep 2 && ps -ef | grep mysql
   sudo mysqld_multi start 5540 && sleep 2 && ps -ef | grep mysql
   sudo mysqld_multi start 5612 && sleep 2 && ps -ef | grep mysql
}

# Stop MySQL function
stop() {
   sudo mysqld_multi stop 5173 && sleep 3 && ps -ef | grep mysql
   sudo mysqld_multi stop 5540 && sleep 3 && ps -ef | grep mysql
   sudo mysqld_multi stop 5612 && sleep 3 && ps -ef | grep mysql
}

# Status function
status() {
   ps -ef | grep mysql
}


# Usage
case "$1" in
    start)
      start
      exit 0
      ;;
    stop)
      stop
      exit 0
      ;;
    status)
      status 
      exit 0
      ;;
    *)
        echo $"Usage: $0 {start|stop|status}"
        exit 0
esac

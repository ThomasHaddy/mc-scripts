#!/bin/bash

SERVER="mc-svr-vanilla-plus"

#######################################
# Prints the usage of the script
# Arguments:
#   NA
# Returns:
#   NA
#######################################
function print_usage()
{
   echo "Usage: $0 [message]"
   echo ""
   echo "[message]"
   echo "backup"
   echo "   Backs up the server"
   echo ""
   echo "cron"
   echo "   Check cron status for the server"
   echo ""
   echo "loc"
   echo "   Location of the server"
   echo ""
   echo "restart"
   echo "   Restarts the server"
   echo ""
   echo "screen"
   echo "   Attach to the server screen session"
   echo ""
   echo "service"
   echo "   List the service config associated with the server"
   echo ""
   echo "start"
   echo "   Starts the server"
   echo ""
   echo "status"
   echo "   Gets the status of the server"
   echo ""
   echo "stop"
   echo "   Stops the server"
   echo ""
}

if [ $# -eq 0 ] || [ $# -gt 1 ]; then
   print_usage
   exit 1
fi

case "${1}" in

   "backup")
      # Shut down the server
      sudo systemctl stop minecraft@${SERVER}.service
      mkdir -p /home/minecraft/backups/${SERVER}

      # Create a backup of the world
      tar cvfz /home/minecraft/backups/${SERVER}/${SERVER}-$(date +"%m-%d-%y").tar.gz /opt/minecraft/${SERVER}/

      # Clear unnused memory
      sync; echo 1 > sudo /proc/sys/vm/drop_caches
      sync; echo 2 > sudo /proc/sys/vm/drop_caches
      sync; echo 3 > sudo /proc/sys/vm/drop_caches

      # Start it back up
      sudo systemctl start minecraft@${SERVER}.service
   ;;

   "cron")
      echo "===================================================="
      echo "Cronjobs"
      echo "===================================================="
      echo "Location of file: /var/spool/cron/crontabs/minecraft"
      crontab -l

      echo "===================================================="
      echo "Service Status"
      echo "===================================================="
      sudo systemctl status cron
   ;;

   "loc")
      echo "===================================================="
      echo "Server Location"
      echo "===================================================="
      echo "Location of Server: /opt/minecraft/${SERVER}"
      ls /opt/minecraft/${SERVER}/
   ;;

   "restart")
      sudo systemctl restart minecraft@${SERVER}.service
   ;;

   "start")
      sudo systemctl enable minecraft@${SERVER}.service
      sudo systemctl start minecraft@${SERVER}.service
   ;;

   "screen")
      screen -r mc-${SERVER}
   ;;

   "service")
      echo "===================================================="
      echo "Server Service"
      echo "===================================================="
      echo "Location of file: /etc/systemd/system/minecraft@${SERVER}.service"
      echo ""
      ls /etc/systemd/system/
   ;;

   "status")
      sudo systemctl status minecraft@${SERVER}.service
   ;;

   "stop")
      sudo systemctl disable minecraft@${SERVER}.service
      sudo systemctl stop minecraft@${SERVER}.service
   ;;

   *)
      echo -e "Invalid ARG: ${1}"
      exit 1
   ;;
esac

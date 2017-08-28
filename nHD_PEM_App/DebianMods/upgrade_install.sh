#!/bin/bash
# Last update:  05/12/2017 
#
#    This script is designed to be ran from a linux development station and requires internet connection to
# the target BB/PEM system.  This assumes the basic pem_install.sh script has been ran but the user wants to
# update files that may change.  Here is a list of the files this script can update:
#
#     BB-BONE-LC4500-00A0.dts -> /lib/firmware/BB-BONE-LC4500-00A0.dtbo
#     <New_Application> -> /usr/bin/lc4500_main
#     <Solutions>.tar.gz -> /opt/lc4500pem/archive/.
#     <Solution Tools> -> /opt/lc4500pem/bin/.
#
#    This script requires superuser priveleges (default) for some operations.
#
#
#
New_Application=lc4500_main_v1.0.1
#New_Overlay=BB-BONE-LC4500-NDC

cur_dir=`pwd`
# Change this IP address to match that of the target BB
target=root@10.10.0.43
#target=root@beaglebone-grn3

echo ========= update target time to local time =============
LocalDate=`date +'%Y-%m-%d %H:%M:%S'`
echo setting target date to $LocalDate
rsh $target date --set=\""$LocalDate"\"



#echo ========= Adding and compiling Device Tree Overlays - SPI, LCD etc. =============
#scp $New_Overlay.dts $target:/lib/firmware/.
#rsh $target dtc -O dtb -o /lib/firmware/BB-BONE-LC4500-00A0.dtbo -b 0 -@ /lib/firmware/$New_Overlay.dts



echo ========= Attempting to kill application in case it is still running =============
rsh $target kill -15 `cat /var/run/lc4500.pid`

echo ========= Installing LC4500 application ==========
scp $New_Application $target:/usr/bin/lc4500_main



#create solutions database directory
echo ========= Creating LC4500 utility directories ==========
# Create Solution root directory
sudo rsh $target mkdir /opt/lc4500pem

# Create/populate Script directory
sudo rsh $target mkdir /opt/lc4500pem/bin
scp Solutions/CheckSolution.sh $target:/opt/lc4500pem/bin/.
scp Solutions/GetSolution.sh $target:/opt/lc4500pem/bin/.
scp Solutions/PutSolution.sh $target:/opt/lc4500pem/bin/.

# Create/populate Solution Archive directory
sudo rsh $target mkdir /opt/lc4500pem/archive
scp Solutions/*.tar.gz $target:/opt/lc4500pem/archive/.




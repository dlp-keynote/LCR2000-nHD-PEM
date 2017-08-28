#!/bin/bash
# Last update:  08/19/2017 (AJK)
#
#    This script is slightly adapted from LC4500-PEM

#    This script is designed to be ran on the BB from the directory where the install files are located.
# This means that the user has already pulled a copy of the install files (including this script)
# onto the BB either through git or some other means.  
#
#    This script should have already been installed from git using the following command line:
#	git clone http://gateway.keynote2.com/LCr4500_APP_BBB LC4500_App_Source
#
#    This script requires superuser priveleges (default) for some operations.
#
#    It should be ran on a clean Debian build (Debian Image 2015-03-01 was used originally). 
#
#    When run, it will perform several "install" operations for the following components:
# - Links will be created for the startup script using update-rc.d command in /etc/init.d/lc4500_startup.sh
# - compile the cape manager overlays (DTS) into DTBO files and place them into the cape manager folder
# - update apt-get and install various libraries required by the application
#
# - May Still need to edit interfaces by hand to be sure the IP address is correct
# - May Still need to disable HDMI in the uEnv.txt file manually since copying it seems to corrupt the BBB
#
cur_dir=`pwd`
target=BB-BONE-LCD-16

echo ========= Installing Startup Script and app ==========
# put application in the correct location
cp $cur_dir/nHD_pem /usr/bin/.
# Now fix startup sequence
cd /etc/init.d
# remove old startup scripts so we can rearrange them
update-rc.d apache2 remove
update-rc.d xrdp remove
# copy new versions with new priorities
cp $cur_dir/StartupScripts/cron .
cp $cur_dir/StartupScripts/dbus .
cp $cur_dir/StartupScripts/rsync .
cp $cur_dir/StartupScripts/udhcpd .
cp $cur_dir/StartupScripts/pem.sh .
update-rc.d pem.sh defaults

echo ========= Installing Device Tree Overlays  =============
cd /lib/firmware
cp $cur_dir/BB-BONE-NHD-00A0.dts .
# compile device tree overlay functions (SPI, HDMI etc.)
dtc -O dtb -o BB-BONE-NHD-00A0.dtbo -b 0 -@ BB-BONE-NHD-00A0.dts
echo ============= AFTER ==================
ls -als BB*

echo ============= Updating the Cape Manager ================
cd /etc/default
cp $cur_dir/capemgr .

echo ============= Check uEnv.txt boot parameters ================
echo Check /boot/uEnv.txt to be sure it is configured to disable HDMI
cp $cur_dir/uEnv.txt /boot/.
cat /boot/uEnv.txt

echo ============= Check Network config ================
#echo Check /etc/network/interfaces to be sure the IP address is correct for this board
echo Check /etc/hostname to be sure the network name is correct:
cat /etc/hostname

###############################################################
# the following should be run once to install dependancies
# required for the application and local build environment.
###############################################################
echo ============= Updating Development Environment ================
#echo apt-get upgrade
echo apt-get update
echo apt-get install libdrm2
echo apt-get install libudev-dev
cd $cur_dir
#Need to add xf86drm.h and other headers to system path to build locally
# Build application
#cd /root/nHD_App_Source
#make




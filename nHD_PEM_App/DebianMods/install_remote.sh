#!/bin/sh
# Last update:  11/17/2015 (JFH)
#
#    This script is designed to be ran from an alternate Linux environment (i.e. development) and will
# copy and install files needed onto the BB at the target address indicated in the variable below (target=).
# It must be ran from the DebianMods folder where all of the install files (including this script) are 
# located.
#
#    The target BB device should be a clean Debian build (Debian Image 2015-03-01 was used originally). 
#
#    When run, it will perform several "install" operations for the following components:
# - compile the cape manager overlays (DTS) into DTBO files and place them into the cape manager file
# - Links will be created for the startup script using update-rc.d command in /etc/init.d/lc4500_startup.sh
# - update apt-get and install various libraries required by the application
#
# - May Still need to disable HDMI in the uEnv.txt file manually since copying it seems to corrupt the BBB
# - should run as su to force updating ECDSA key fingerprint if the target name is the same for several boards!
#

# Change this IP address to match that of the target BB
#target=root@10.10.0.28
target=root@beaglebone


echo ========= update target time to local time =============
LocalDate=`date +'%Y-%m-%d %H:%M:%S'`
echo setting target date to $LocalDate
rsh $target date --set=\""$LocalDate"\"

echo ========= Adding and compiling Device Tree Overlays - SPI, LCD etc. =============
scp BB-BONE-LC4500-00A0.dts $target:/lib/firmware/.
rsh $target dtc -O dtb -o /lib/firmware/BB-BONE-LC4500-00A0.dtbo -b 0 -@ /lib/firmware/BB-BONE-LC4500-00A0.dts

echo ========= Adding Cape Manager =============
scp capemgr $target:/etc/default/.

echo ========= Checking uEnv.txt file on target BB Cape =============
echo uEnv.txt file must disable HDMI and video time out
#scp uEnv.txt $target:/boot/.
#rsh $target cat /boot/uEnv.txt

echo ========= Installing LC4500 application ==========
scp lc4500_main $target:/usr/bin/.

echo ========= Add and Install Startup Script ==========
scp StartupScripts/cron $target:/etc/init.d/.
scp StartupScripts/dbus $target:/etc/init.d/.
scp StartupScripts/rsync $target:/etc/init.d/.
scp StartupScripts/udhcpd $target:/etc/init.d/.
scp StartupScripts/lc4500_startup.sh $target:/etc/init.d/.
rsh $target update-rc.d apache2 remove
rsh $target update-rc.d xrdp remove
rsh $target update-rc.d lc4500_startup.sh defaults

echo ========= Updating Aptitude libraries on target BB ==========
rsh $target apt-get update
echo ========================= libdrm
rsh $target apt-get install libdrm2
echo ========================= libudev
rsh $target apt-get install libudev-dev

###############################################################
# Optionally, the following should be used to create a local
# build environment for the application so no cross-compile 
# is required.
#(Several dependancies must also be installed using local script)
###############################################################

# Add Header files for target build environment (DebianMods/*.h)
#scp ../xf86drm.h $target:/usr/include/.
#scp ../xf86drmMode.h $target:/usr/include/.
#scp ../drm.h $target:/usr/include/.
#scp ../drm_mode.h $target:/usr/include/.

# Copy Source directory to target
#scp -r ../../LC4500_BBB $target:/root/LCr4500_App_Source


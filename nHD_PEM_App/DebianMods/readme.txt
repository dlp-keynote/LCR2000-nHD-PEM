nHD-PEM Configuration READMe.txt
++++++++++++++++++++++++++++++++++++

The files in this folder are intended to be used to modify the default install of the Debian:
=====================================================================================================================
 - Use Windows Win32DiskImager to create the flasher uSD Card to be used to initialize BBB with this image file:

   BBB-eMMC-flasher-debian-7.5-2014-05-14-2gb.img
or (updated)
   BBB-eMMC-flasher-debian-7.8-lxde-4gb-armhf-2015-07-28-4gb.img
or (newer)
   bone-debian-7.11-lxde-4gb-armhf-2016-06-15-4gb.img
converted to this (includes our app so no other mods needed):
   ### WRONG ##### LC4500-PEM_BBG_v7.11_app_v0.8.0_2016-12-20.img

 - Insert uSD Card into BBB and boot the card while holding config switch during startup to begin NAND flash reprogramming.
 - After running the flasher uSDcard to install the default Debian build, boot the board without the uSDcard and verify the version:

  cat /etc/dogtag 
or 
  cat /ID.txt 
or
  cat /etc/debian_version

 - Optionally modify the name of the board (default = 'beaglebone') here:

  vi /etc/hostname


Next, clone this application repository to the Beaglebone

git clone https://github.com/keynotep/LCR2000-nHD-PEM/nHD_PEM_App

 cd nHD_PEM_App/DebianMods
 ./pem_install.sh

==> Note that /boot/uEnv.txt will be modified:
   - Adds the following line to remove 10 minute display turn-off
          optargs="consoleblank=0"
   - Turns off X-Windows by adding the word 'text' to the command line.  It should look something like this when you are done:
          cmdline=text dms.debug=7 coherent_pool=1M quiet init=/lib/systemd/systemd
   - Disables HDMI.  
 ##Disable HDMI (v3.8.x)
          cape_disable=capemgr.disable_partno=BB-BONELT-HDMI,BB-BONELT-HDMIN


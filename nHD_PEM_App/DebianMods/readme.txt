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


==> Run one of the following scripts depending on your situation to copy and install the needed components into the BB environment:
   => For local build/run of application run the following from the BB command line:
 git clone http://keynote2.com/nHD_PEM nHD_App_Source
 cd nHD_App_Source/DebianMods
 ./install_local.sh
(This is the script to install files if they are already on the BB)

or => For remote installation from a development machine, run the following from the command line of the development machine:
(if needed modify target=root@beaglebone.local to the target BB name/IP address)
 vi install_remote.sh
 ./install_remote.sh
(This is the script to copy and install the files onto a BB from a development environment)

==> You will need to manually log into the BB and edit /boot/uEnv.txt:
   - Add the following line to remove 10 minute display turn-off
 optargs="consoleblank=0"
   - Turn off X-Windows by adding the word 'text' to the command line.  It should look something like this when you are done:
 cmdline=text dms.debug=7 coherent_pool=1M quiet init=/lib/systemd/systemd
   - Uncomment the line that disables HDMI.  It is not compatible with SPI or the DRM modes used in the DDM application.
 ##Disable HDMI (v3.8.x)
 cape_disable=capemgr.disable_partno=BB-BONELT-HDMI,BB-BONELT-HDMIN

To install local development, the following must be done (or uncomment these steps in the install scripts to perform the steps as part of the above process:
=====================================================================================================================
 - Install Headers
 - Install Source code


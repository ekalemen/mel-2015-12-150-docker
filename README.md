# mel-2015-12-150-docker
Dockerfile and scripts for creating and running Docker image with MGC installed tools

Files:
 1.Dockerfile - File for bild Docker image
 2.license.txt - MGC license file for ethernet MAC address 02:42:ac:11:00:02 (this MAC address is provided to image by Docker daemon in build time if no any other Docker images have been running)
 3.mgc-tools-pckg-dep - MGC tools depended packages file. If you need to add some additional packages to image, please add them to this file. Dockerfile read this file and install to system everything. 
 4.mgc-tools-urls - File with URLs to MGC tools installers. If you need to add or to delete some MGC tools, please use this file. create-image.sh script uses this file to download MGC tools installers or check that these installers have downloaded before starting build Docker image. Order in this file is important, because with same order Dockerfile will istall MGC tools.
 5.create-image.sh - script for downloading MGC tools installers, checking for no any other Docker images  running, and building Docker image with special arguments
 6.run-image.sh - script for starting Docker image with special parameters
 
 How this work:
 ====under construction======
 
 How this use:
 1. Install Docker CE on your Linux operation system
 2. Clone these files to your PC
 3. 
 
 
 

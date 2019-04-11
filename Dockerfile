FROM ubuntu:16.04                                                                
MAINTAINER Eugeny Kalemenev <eugeny_kalemenev@mentor.com>

# Docker conteiner for MEL 2015.12.150 v.01
# Using Ubuntu 16.04 as a base OS for build environment

# Upgrade system 
RUN apt-get update && apt-get -y upgrade 

# Set up locales                                                                 
RUN apt-get -y install locales apt-utils sudo && dpkg-reconfigure locales && locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8     

# Install MEL dependencies
COPY mgc-tools-pckg-dep /tmp/
RUN	DEBIAN_FRONTEND=noninteractive apt-get -y install `cat /tmp/mgc-tools-pckg-dep`

# Clean up APT when done.                                                        
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*               
                                                                                 
# Replace dash with bash                                                         
RUN rm /bin/sh && ln -s bash /bin/sh        

# Default values for user management. They have to be replace with build args.
ARG UNAME=testuser
ARG UID=1000
ARG GID=1000        

# User management (create the same user as in the host os with same gid and uid)                                                                
RUN groupadd -g $GID $UNAME && useradd -u $UID -g $GID -ms /bin/bash $UNAME && usermod -a -G sudo $UNAME && usermod -a -G users $UNAME 	

# Run as build user from the installation path                                   
ENV MEL_INSTALL_PATH "/opt/mgc/embedded"                 
ENV MEL_LICENSE_PATH "/opt/mgc/licenses"                             
RUN install -o $UID -g $GID -d $MEL_INSTALL_PATH                    
RUN install -o $UID -g $GID -d $MEL_LICENSE_PATH            
USER $UNAME

#Copy license file into container. NOTE: You need license file for interface MAC address.  
WORKDIR $MEL_LICENSE_PATH
COPY license.txt ./

WORKDIR /home/$UNAME  
# Copy Mentor tools installers and file with urls (for install order) into container to the workdir 
COPY *.bin ./
COPY mgc-tools-urls ./

# Set full path to license file
ENV MEL_LICENSE "$MEL_LICENSE_PATH/license.txt"

# Install Mentor tools
RUN for i in `cat mgc-tools-urls`; do echo "Installing ${i##*/}" && ./${i##*/} -console -license=$MEL_LICENSE -location=$MEL_INSTALL_PATH -silent; done 

# Clean - kill distrib files
RUN rm *.bin

# Export MGLS_LICENSE_FILE 
ENV MGLS_LICENSE_FILE $MEL_LICENSE
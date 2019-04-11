#!/bin/bash

#Docker image name and tag
DOCKER_IMAGE_NAME="ubuntu16"
DOCKER_IMAGE_TAG="mel-2015-12-150"

#URLs for MGC tool installers 
URL_MGC_TOOL_INSTALLERS=(`cat mgc-tools-urls`)

#Color set defines
SETCOLOR_SUCCESS="-en \\033[1;32m" #зеленый
SETCOLOR_FAILURE="-en \\033[1;31m" #красный
SETCOLOR_WARNING="-en \\033[1;33m" #желтый
SETCOLOR_NORMAL="-en \\033[0;39m" #тот что установлен в терминале по умолчанию

#Status binary values
STATUS_MSG_OK=1
STATUS_MSG_ERROR=2
STATUS_MSG_WARNING=3

#Status string values
MESSAGE_OK="[OK]"
MESSAGE_ERROR="[ERROR]"
MESSAGE_WARNING="[WARN]"

#Function for printing status messages 
print_status_msg()
{
	if [ $1 -eq $STATUS_MSG_OK ]; then
		echo $SETCOLOR_SUCCESS$MESSAGE_OK && echo $SETCOLOR_NORMAL$2 && echo
	elif [[ $1 -eq STATUS_MSG_WARNING ]]; then
		echo $SETCOLOR_WARNING$MESSAGE_WARNING && echo $SETCOLOR_NORMAL$2 && echo
	else
		echo $SETCOLOR_FAILURE$MESSAGE_ERROR && echo $SETCOLOR_NORMAL$2 && echo
	fi
}

#If MGC tool installers did not download yet, try to do this
for i in "${URL_MGC_TOOL_INSTALLERS[@]}"; do 
	if test -e "${i##*/}"; then 
		print_status_msg $STATUS_MSG_OK "${i##*/} is present" 
	else
		wget $i
		if [[ $? -ne 0 ]]; then
			print_status_msg $STATUS_MSG_ERROR "Can't download ${i##*/}"
			exit 1
		else
			chmod a+x "${i##*/}"
			print_status_msg $STATUS_MSG_OK "${i##*/} is present" 
		fi
	fi
done

#Start build Docker image
DUNAME=`id -un`
DUID=`id -u`
DGID=`id -g`

#Check for currently running containers
if test -n "`sudo docker ps -a | grep Up`"; then
	print_status_msg $STATUS_MSG_ERROR "Running containers was found! Please exit from all other docker images."
	exit 1
fi			

sudo docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG --build-arg UNAME=$DUNAME --build-arg UID=$DUID --build-arg GID=$DGID .

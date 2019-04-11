#!/bin/bash

DUNAME=`id -un`
sudo  docker run -it --rm --mount src=/home/$DUNAME,target=/home/$DUNAME,type=bind ubuntu16:mel-2015-12-150

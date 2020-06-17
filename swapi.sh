#!/bin/bash

#**********************************#
#              swapi.sh            #
#                                  #
#       author: rick@gnous.eu      #
#           licence: GPL3          #
#**********************************#

if [ $UID -ne 0 ]
then
    echo "Lancez ce fichier en root."
    exit 100
fi

sizeSwap=${1:--1}
if [ $sizeSwap -lt 1 ]
then
    echo "Utilisation: swapi.sh [Taille du swap]"
    echo "Si taille du swap = 1 alors il prendra 512Mo"
    exit 1
fi

dd if=dev/zero of=/swapfile count=${sizeSwap}M
mkswap /swapfile
echo >> /etc/fstab
echo "# Swap" >> /etc/fstab
echo "/swapfile	none	swap	sw,loop	0 0" >> /etc/fstab

echo "Vérifiez que le swap est bien activé grace à la commande : sudo swapon --show"

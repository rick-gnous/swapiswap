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

pathFileSwap="/swapfile"
if [ -e $pathFileSwap ]
then
    read -p "Le fichier swapfile existe déjà à la racine. Le (S)upprimer, le (R)emplacer, (A)nnuler > " fileSwap
    case "$fileSwap" in
        s | S )
            swapoff -v $pathFileSwap
            rm /swapfile
        ;;
        r | R )
            read -p "Indiquez le chemin vers le nouveau fichier swap > " pathFileSwap
        ;;
        * )
            echo "Annulation..."
            exit 0
        ;;
    esac
fi

echo "Creation du swap"
dd if=/dev/zero of=$pathFileSwap count=${sizeSwap}M
chmod 600 $pathFileSwap
mkswap $pathFileSwap

echo "Mise à jour du fstab"
echo >> /etc/fstab
echo "# Swap genere avec swapi !" >> /etc/fstab
echo "$pathFileSwap none	swap	sw,loop	0 0" >> /etc/fstab

echo "Montage du swap"
swapon $pathFileSwap

echo "Vérifiez que le swap est bien activé grace à la commande : sudo swapon --show"

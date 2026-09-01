#!/bin/bash

data="$(date +%Y%m%d_%H%M)"

if [ -d /Zanthus/Zeus/path_comum_servidor ]; then
	if mount | grep -q path_comum_servidor; then
		if [ -d /Zanthus/Zeus/path_comum_servidor/Descanso ]; then
			rsync -ah /Zanthus/Zeus/path_comum_servidor/Descanso /Zanthus/Zeus/backup_"$data"/
			rm -rf /Zanthus/Zeus/path_comum_servidor/Descanso
		fi
		cp -rf /Zanthus/Zeus/pdvJava/pdvGUI/guiConfigProj /Zanthus/Zeus/path_comum_servidor/Descanso
	fi
fi

if [ -d /Zanthus/Zeus/path_comum ]; then
	if mount | grep -q path_comum; then
		if [ -d /Zanthus/Zeus/path_comum/Descanso ]; then
			rsync -ah /Zanthus/Zeus/path_comum/Descanso /Zanthus/Zeus/backup_"$data"/
			rm -rf /Zanthus/Zeus/path_comum/Descanso
		fi
		cp -rf /Zanthus/Zeus/pdvJava/pdvGUI/guiConfigProj /Zanthus/Zeus/path_comum/Descanso
	fi
fi

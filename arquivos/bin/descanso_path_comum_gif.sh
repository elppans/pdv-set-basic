#!/bin/bash

data="$(date +%Y%m%d_%H%M)"

if [ -d /Zanthus/Zeus/path_comum_servidor ]; then
  if mount | grep -q path_comum_servidor ; then
    if [ -d /Zanthus/Zeus/path_comum_servidor/Descanso ];then
	rsync -ah /Zanthus/Zeus/path_comum_servidor/Descanso /Zanthus/Zeus/backup_"$data"/ ;
	cp -rf /Zanthus/Zeus/pdvJava/pdvGUI/guiConfigProj/imagens/saida_animada.gif /Zanthus/Zeus/path_comum_servidor/Descanso/imagens/
    fi
  fi
fi

if [ -d /Zanthus/Zeus/path_comum ]; then
  if mount | grep -q path_comum ; then
    if [ -d /Zanthus/Zeus/path_comum/Descanso ];then
	rsync -ah /Zanthus/Zeus/path_comum/Descanso /Zanthus/Zeus/backup_"$data"/ ;
	cp -rf /Zanthus/Zeus/pdvJava/pdvGUI/guiConfigProj/imagens/saida_animada.gif /Zanthus/Zeus/path_comum/Descanso/imagens/
    fi
  fi
fi




#!/bin/bash

cmd="$0"
basecmd="$(readlink -m "$cmd")"
dircmd="$(dirname "$basecmd")"
LOCALSH="$dircmd"
PDVPATH="/Zanthus/Zeus/pdvJava"
PATH="$LOCALSH:$PATH"
export PDVPATH
export PATH

cd "$PDVPATH" || exit 1
#pwd
#chmod +x xmlstarlet
#./xmlstarlet --version 2>/dev/null

#sel -t -c "//CODLOJA" -n \
#               -c "//NUMEROPDV" -n \
#               -c "//IP" INFOPDV.xml

#xmlstarlet sel -t -v "//CODLOJA" -n \
#               -v "//NUMEROPDV" -n \
#               -v "//IP" INFOPDV.xml

#ls INFOPDV*
echo __________
echo "Loja: $(xmlstarlet sel -t -v "//CODLOJA" -n ./INFOPDV.XML )" 2>/dev/null
echo "ECF: $(xmlstarlet sel -t -v "//NUMEROPDV" -n ./INFOPDV.XML )" 2>/dev/null
echo "IP: $(xmlstarlet sel -t -v "//IP" -n ./INFOPDV.XML )" 2>/dev/null
echo "SO: $(xmlstarlet sel -t -v "//DISTRO_SO" -n ./INFOPDV.XML )" 2>/dev/null
echo __________
if [ -f /etc/canoalinux-release ];then
echo "CANOALINUX:"
cat /etc/canoalinux-release
else
	echo "CANOALINUX: (Arquivo não existe)"
	echo "PDV V. 12.04 R. 2X"
fi
echo __________
echo "Dispositivos de armazenamento (0 = SSD/NVME, 1 = HDD, loop = Dispositivo de Bloco Virtual)"
if ! lsblk -d -o name,rota 2>/dev/null ;then
echo -e "NAME   ROTA" &&
for d in /sys/block/*; do
    [ -f "$d/queue/rotational" ] && echo "$(basename "$d"): $(cat "$d/queue/rotational")"
done
fi
echo __________
lscpu | grep -i -E 'Model:|Modelo:'
lscpu | grep -i 'CPU(s):'
echo __________
free -h
echo __________
echo "lsusb:"
lsusb
echo __________
echo ==========
echo

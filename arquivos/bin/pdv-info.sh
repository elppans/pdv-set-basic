#!/bin/bash

cd /Zanthus/Zeus/pdvJava || exit 1
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
echo "Loja: $(./xmlstarlet sel -t -v "//CODLOJA" -n ./INFOPDV.XML )" 2>/dev/null
echo "ECF: $(./xmlstarlet sel -t -v "//NUMEROPDV" -n ./INFOPDV.XML )" 2>/dev/null
echo "IP: $(./xmlstarlet sel -t -v "//IP" -n ./INFOPDV.XML )" 2>/dev/null
echo "SO: $(./xmlstarlet sel -t -v "//DISTRO_SO" -n ./INFOPDV.XML )" 2>/dev/null
echo __________
if [ -f /etc/canoalinux-release ];then
echo "CANOALINUX:"
cat /etc/canoalinux-release
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

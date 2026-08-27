#!/bin/bash
cat /Zanthus/Zeus/pdvJava/CLAZ.CFG | grep -E "LOJA|CNPJ" | grep -v '#'
echo -e "---
Nome do PDV:
$(hostname)
IP do PDV: 
$(hostname -i)
DNS do PDV: 
$(cat /etc/resolv.conf)
---"


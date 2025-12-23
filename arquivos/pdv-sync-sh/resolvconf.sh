#!/bin/bash

echo -e "---
cat /Zanthus/Zeus/pdvJava/CLAZ.CFG | grep -E "LOJA|CNPJ" | grep -v '#'
Nome do PDV:
$(hostname)
IP do PDV: 
$(hostname -i)
DNS do PDV: 
$(cat /etc/resolv.conf)
---"


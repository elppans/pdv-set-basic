#!/bin/bash

echo -e " ---
Nome do PDV:
$(hostname)
IP do PDV: 
$(hostname -i)
DNS do PDV: 
$(cat /etc/resolv.conf)
---"


#!/bin/bash
#
# Gerar uma senha aleatória de 9 caracteres (misturando letras e números) diretamente no terminal
# lê bytes aleatórios do sistema, filtra apenas letras maiúsculas, minúsculas e números, limita a saída para 9 caracteres.

head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c9
echo

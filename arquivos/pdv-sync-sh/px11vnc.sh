#!/bin/bash
#
# ============================================================
# Script: px11vnc.sh
#
# Objetivo:
#   Automatizar a configuração da senha do x11vnc.
#   O script lê a senha do arquivo "px11vnc.txt" e grava
#   diretamente no arquivo /root/.vncpasswd sem interação.
#
# Como usar:
#   1. Crie um arquivo chamado "px11vnc.txt" no mesmo diretório do script.
#   2. Dentro dele, coloque apenas a senha desejada para o x11vnc.
#
#      Exemplo de px11vnc.txt:
#        MinhaSenhaSecreta
#
#   3. Dê permissão de execução ao script:
#        chmod +x px11vnc.sh
#
#   4. Execute o script como root (ou via sudo):
#        ./px11vnc.sh
#
# Observações:
#   - O arquivo /root/.vncpasswd será sobrescrito com a nova senha.
#   - O script precisa ser executado com privilégios administrativos.
#   - A senha fica em texto puro dentro de px11vnc.txt, considere
#     proteger esse arquivo (permissões restritas).
# ============================================================

ARQUIVO_SENHA="px11vnc.txt"
DESTINO="/root/.vncpasswd"

# Verifica se o arquivo existe
if [[ ! -f "$ARQUIVO_SENHA" ]]; then
    echo "Arquivo $ARQUIVO_SENHA não encontrado!"
    exit 1
fi

# Lê a senha (primeira linha do arquivo)
SENHA=$(head -n 1 "$ARQUIVO_SENHA")

# Grava a senha no destino sem interação
x11vnc -storepasswd "$SENHA" "$DESTINO"

echo "Senha do x11vnc configurada em $DESTINO."
rm -rf "$ARQUIVO_USUARIOS" &>>/dev/null

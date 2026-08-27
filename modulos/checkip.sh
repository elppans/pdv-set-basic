#!/bin/bash
# shellcheck disable=SC2013

# Variáveis para o ambiente
IP_DIR="$HOME/.ip"
IP_FILE="$IP_DIR/ip.txt"
IP_OK_FILE="$IP_DIR/ip_ok.txt"
IP_OFF_FILE="$IP_DIR/ip_off.txt"

# Exportar variáveis do ambiente
export IP_DIR
export IP_FILE
export IP_OK_FILE
export IP_OFF_FILE

# cria diretório de configuração, se não existir
mkdir -p "$IP_DIR"

# Função para verificar se o arquivo ip.txt existe
check_ip_file_exists() {
    if [ ! -f "$IP_FILE" ]; then
        echo "Erro: O arquivo $IP_FILE não existe."
        exit 1
    fi
}

# Executa função de verificação do arquivo ip.txt
check_ip_file_exists

# Limpa os arquivos, mantendo ip.txt antes de prosseguir
rm -rf "$IP_OK_FILE" >>/dev/null
rm -rf "$IP_OFF_FILE" >>/dev/null

# Testa comunicação com os IPs configurados em ip.txt
# Se a comunicação estiver OK, será gravado em ip_ok.txt
# Se a comunicação falhar, será gravado em ip_off.txt
for IP in $(cat "$IP_FILE"); do
    if ping -c 1 "$IP" >>/dev/null; then
        echo "Conexão com $IP OK"
        echo "$IP" >>"$IP_OK_FILE"
    else
        echo "Conexão com $IP OFFLINE"
        echo "$IP" >>"$IP_OFF_FILE"
    fi
done

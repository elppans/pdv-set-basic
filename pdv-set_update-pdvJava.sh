#!/bin/bash
# shellcheck disable=SC1078,SC1079,SC2013,SC2140
# shellcheck source=/dev/null

# Verifica se o primeiro parâmetro foi fornecido
# if [ -z "$1" ]; then
#     echo "Você não forneceu nenhum valor. Por favor, insira um valor para o usuario."
#     exit 1
# fi

# if [ -z "$2" ]; then
#     echo "Você não forneceu nenhum valor. Por favor, insira um valor para a senha."
#     exit 1
# fi

# Variáveis para o ambiente
IP_DIR="$HOME/.ip"
IP_FILE="$IP_DIR/ip.txt"
IP_OK_FILE="$IP_DIR/ip_ok.txt"
IP_OFF_FILE="$IP_DIR/ip_off.txt"
ssh_options="-o StrictHostKeyChecking=no -t"
rsync_options="-ahvz --no-checksum --no-owner --no-group -e"
localstate="America/Sao_Paulo"
PWDFILES="$(pwd)/arquivos"
WEBFILES="/Zanthus/Zeus/Update_Files_pdvJava"
DIRPDVJAVA="/Zanthus/Zeus/pdvJava"

# Exportar variáveis do ambiente
export IP_DIR
export IP_FILE
export IP_OK_FILE
export IP_OFF_FILE
export ssh_options
export localstate
export PWDFILES
export WEBFILES
export DIRPDVJAVA

mkdir -p "$IP_DIR"

# Se o parâmetro foi fornecido, atribui-o à variável
passwd="zanthus"
export passwd


# Executar comandos via SSH, usando IP atribuido ao arquivo ip_OK.txt
for IP in $(cat "$IP_OK_FILE"); do
    echo "Ajustando conexão do endereço IP: $IP"
    ./ssh-keyscan.sh "$IP" &>>/dev/null

# Função para sincronização de diretório
    ssh_sync() {
        # echo -e "
        sshpass -p ""$passwd"" \
        rsync ""$rsync_options"" \
        "ssh ""$ssh_options""" \
        ""$PWDFILES""/ root@""$IP"":""$WEBFILES""/
        # "
    }

# Verifica a versão do Ubuntu e executa os comandos apropriados
echo "Verificando usuário ssh..."
pdv_sshuservar() {
if sshpass -p ""$passwd"" ssh ""$ssh_options"" user@"$IP" "lsb_release -r | grep -q '16.04'" &>>/dev/null; then
    user="user"
    export user
elif sshpass -p ""$passwd"" ssh ""$ssh_options"" zanthus@"$IP" "lsb_release -r | grep -q '22.04'"; then
    user="zanthus"
    export user
elif sshpass -p ""$passwd"" ssh ""$ssh_options"" zanthus@"$IP" "lsb_release -r | grep -q '12.04'"; then
    user="zanthus"
    export user
else
    echo "Não foi possível verificar o sistema do IP \"$IP\""
fi
}
    pdv_sshuservar

    # Faz a configuração de diretórios
    sshpass -p "$passwd" ssh ""$ssh_options"" "$user"@"$IP" \
        "
        # Shell/CMD
        echo ""$passwd"" | sudo -S chmod -R 777 /Zanthus/Zeus
        echo ""$passwd"" | sudo -S mkdir -m 777 -p "$WEBFILES"
        # Shell/CMD
        "

        # Faz a sincronização via Função SSH
        ssh_sync

        sshpass -p "$passwd" ssh ""$ssh_options"" "$user"@"$IP" \
        "
        # Shell/CMD
        echo -e "\nAnalisando versão do PDV..."
        cat /etc/canoalinux-release
        echo "Atualizando arquivos..."
        cd "$WEBFILES"
        tar -zxf pdvGUI.tar.gz && rm -rf pdvGUI.tar.gz
        echo ""$passwd"" | sudo -S rsync "$rsync_options" "$WEBFILES"/ "$DIRPDVJAVA"
        echo "Atualização finalizada!"
        echo " "
        # Shell/CMD
        "
done

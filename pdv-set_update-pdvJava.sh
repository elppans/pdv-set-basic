#!/bin/bash
# shellcheck disable=SC2002,SC1010,SC1012,SC1078,SC1079,SC2001,SC2013,SC2027,SC2046,SC2086,SC2140,SC2317
# shellcheck source=/dev/null

# Função para verificar se um comando existe
verifica_comando() {
    comando=$1

    if ! command -v "$comando" &>/dev/null; then
        echo "Erro: O comando '$comando' não está instalado. Por favor, instale-o antes de continuar."
        exit 1
    fi
}

# Verifica se os comandos necessários estão instalados
verifica_comando sshpass
verifica_comando ssh
verifica_comando rsync

# Caso todos os comandos existam, o script pode continuar normalmente
# echo "Todos os comandos necessários estão instalados."

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

# Sobre o rsync:
# rsync. Sincronismo com a opção de progresso, não mostra os arquivos que serão sincronizados
# rsync. Sincronismo padrão, mais seguro e em modo verbose
# rsync. Substituido -a (archive) por -rl. -r (Recursivo)/-l (Preserva links simbólicos.)
# rsync. A substituição elimina redundâncias, mantendo o mesmo comportamento esperado.
# rsync local. Quando for um comando local, removendo a opção '-e'. Uso para função "executar_comando_ssh"
# rsync "--update". Copia apenas arquivos que são mais novos na origem do que no destino, ou que não existem no destino.
IP_DIR="$HOME/.ip"
IP_FILE="$IP_DIR/ip.txt"
IP_OK_FILE="$IP_DIR/ip_ok.txt"
IP_OFF_FILE="$IP_DIR/ip_off.txt"
# rsync_options="-rlhvz --no-checksum --no-owner --no-group --no-times --no-perms --links -e"
# rsync_options="-rlhvz --update --no-checksum --no-owner --no-group --no-times --no-perms --links -e"
rsync_options="-rlhz --info=progress2 --no-checksum --no-owner --no-group --no-times --no-perms --links -e"
rsync_options_local="$(echo $rsync_options | sed 's/ -e//')"
localstate="America/Sao_Paulo"
PINGFILE="$(pwd)/pdv-set_ping.sh"
SSHKEYSCFILE="$(pwd)/ssh-keyscan.sh"
PWDFILES="$(pwd)/arquivos"
WEBFILES="/tmp/Update_pdvJava_dir"
DIRPDVJAVA="/Zanthus/Zeus/pdvJava"

# Exportar variáveis do ambiente
export IP_DIR
export IP_FILE
export IP_OK_FILE
export IP_OFF_FILE
export rsync_options
export rsync_options_local
export localstate
export PINGFILE
export SSHKEYSCFILE
export PWDFILES
export WEBFILES
export DIRPDVJAVA

# Se o parâmetro foi fornecido, atribui-o à variável (${1/2})
# user="$1"
passwd="zanthus"
# export user
export passwd

# Verifica a versão do SSH
ssh_version=$(ssh -V 2>&1 | awk -F '[^0-9]*' '{print $2}')
export ssh_version

# Compara a versão do SSH
# Não verificar a chave do host,
# automatizar a gravação da chave do host em cache na primeira conexão e
# não exibir nenhuma mensagem no terminal relacionada à verificação da chave do host.
if [[ $(echo "$ssh_version >= 7.6" | bc -l) -eq 1 ]]; then
    # As opções "-o UserKnownHostsFile=/dev/null" e  "-o LogLevel=QUIET" são suportados a partir do OpenSSH 7.6
    # Algorítmos "ssh-rsa e ssh-dss". versões mais recentes do OpenSSH desativaram, por padrão, os algoritmos de host keys como ssh-rsa e ssh-dss por questões de segurança.
    # A solução para que o Script funcione TAMBÈM para o Ubuntu 12.04, foi adicionar a opção HostKeyAlgorithms ao comando para permitir o uso de ssh-rsa.
    # ssh_options="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET"
    ssh_options="-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET"
else
    # Configuração para Sistemas com SSH antigo.
    # ssh_options="-o StrictHostKeyChecking=no"
    ssh_options="-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa -o StrictHostKeyChecking=no"
fi

# Exporta a configuração SSH
export ssh_options

# Exibe a configuração
# echo "ssh_options=\"$ssh_options\""

# Verifica se o arquivo especificado em PINGFILE existe
if [ ! -f "$PINGFILE" ]; then
    echo "Erro: O arquivo '$PINGFILE' não existe. Por favor, crie-o ou especifique o caminho correto."
    exit 1
fi

# Função para executar o PINGFILE
executar_ping() {
    echo
    echo "Executando teste de comunicação..."
    echo
    # Executa o script especificado em PINGFILE sem argumentos
    bash "$PINGFILE"
}

# Verifica se o arquivo especificado em SSHKEYSCFILE existe
if [ ! -f "$SSHKEYSCFILE" ]; then
    echo "Erro: O arquivo '$SSHKEYSCFILE' não existe. Por favor, crie-o ou especifique o caminho correto."
    exit 1
fi

# Função para executar o SSHKEYSCFILE
executar_ssh_keyscan() {
    local IP="$1" # Recebe o IP como argumento

    echo
    echo "Ajustando conexão do endereço IP: $IP"

    if [ -z "$IP" ]; then
        echo "Erro: Nenhum IP fornecido."
        exit 1
    fi

    # Executa o script especificado em SSHKEYSCFILE passando o IP como argumento
    bash "$SSHKEYSCFILE" "$IP"
}

# Verifica se o diretório especificado em PWDFILES existe
if [ ! -d "$PWDFILES" ]; then
    echo "Erro: O diretório '$PWDFILES' não existe. Por favor, crie-o ou especifique o caminho correto."
    exit 1
fi

pdv_sshuservar() {
    echo "Verificando usuário ssh..."
    if sshpass -p ""$passwd"" ssh ""$ssh_options"" user@"$IP" "lsb_release -r | grep -q '16.04'" &>>/dev/null; then
        user="user"
        export user
        echo "Usuário $user em PDV 16.04"
    elif sshpass -p ""$passwd"" ssh ""$ssh_options"" zanthus@"$IP" "lsb_release -r | grep -q '22.04'"; then
        user="zanthus"
        export user
        echo "Usuário $user em PDV 22.04"
    elif sshpass -p ""$passwd"" ssh ""$ssh_options"" zanthus@"$IP" "lsb_release -r | grep -q '12.04'"; then
        user="zanthus"
        export user
        echo "Usuário $user em PDV 12.04"
    elif sshpass -p ""$passwd"" ssh ""$ssh_options"" zanthus@"$IP" "lsb_release -r"; then
        user="root"
        export user
        echo "Usuário $user em PDV..."
    else
        echo "Não foi possível verificar o sistema do IP \"$IP\""
    fi
}

# Função para sincronização de diretório
ssh_sync() {
    echo
    echo "Sincronizando diretório remoto..."
    # echo -e "
    sshpass -p "$passwd" \
        rsync ""$rsync_options"" \
        "ssh ""$ssh_options""" \
        ""$PWDFILES""/ $user@""$IP"":""$WEBFILES""/
    # "
}

# Função para executar comando via SSH
executar_comando_ssh() {
    local comando_ssh="$1"

    # Certifique-se de que as variáveis necessárias estão definidas
    if [[ -z "$passwd" || -z "$ssh_options" || -z "$user" || -z "$IP" || -z "$WEBFILES" || -z "$rsync_options" || -z "$DIRPDVJAVA" ]]; then
        echo "Erro: Uma ou mais variáveis necessárias não estão definidas."
        return 1
    fi

    # Executa comandos via SSH
    echo "Executando comandos via SSH..."
    sshpass -p "$passwd" ssh ""$ssh_options"" "$user"@"$IP" "
        # Shell/CMD
        # Executar os comandos passados para a função
        $comando_ssh
        # End Shell/CMD
    "
}

# Execução dos comandos e funções

# Criação do diretório ".ip"
mkdir -p "$IP_DIR"

# Chama a função para executar o script PINGFILE
executar_ping

# Executar comandos via SSH, usando IP atribuido ao arquivo ip_OK.txt
for IP in $(cat "$IP_OK_FILE"); do

    # Chamada para a função para o scan SSH do "IP"
    executar_ssh_keyscan "$IP"

    # Verifica a versão do Ubuntu e executa os comandos apropriados
    pdv_sshuservar

    # Cria e modifica permissões de diretórios específicos
    # Chamando a função para executar os comandos via SSH
    executar_comando_ssh "
    echo 'Criando diretório temporário...'
    echo \"$passwd\" | sudo -S chmod -R 777 \"$DIRPDVJAVA\" &>>/dev/null
    echo \"$passwd\" | sudo -S mkdir -m 777 -p \"$WEBFILES\" &>>/dev/null
"

    # Faz a sincronização local para remoto via Função RSync e SSH
    ssh_sync

    # Faz a sincronização de diretórios locais via acesso SSH, usando RSync
    # rsync versão menor que 3.1.0 não tem suporte à opção "--info=progress2";
    # Solução para cópia local em TODAS AS VERSÕES do rsync, e portanto sistema como o Ubuntu 12 é trocar para "--stats".
    rsync_options_local="$(echo $rsync_options_local | sed 's/--info=progress2/--stats/')"
    export rsync_options_local

    # Chamando a função para executar os comandos via SSH
    # A execução da função suporta apenas comandos diretos
    executar_comando_ssh "
    # echo 'Analisando versão do PDV...'
    # cat /etc/canoalinux-release
    echo 'Atualizando arquivos...'
    cd \"$WEBFILES\"
    echo \"$passwd\" | sudo -S umount -f /Zanthus/Zeus/path_comum
    echo \"$passwd\" | sudo -S umount -f /Zanthus/Zeus/path_comum_servidor
    echo \"$passwd\" | sudo -S rm -rf /Zanthus/Zeus/path_comum/Descanso /Zanthus/Zeus/path_comum_temp/Descanso
    echo \"$passwd\" | sudo -S rm -rf /Zanthus/Zeus/path_comum/GERALCFG/ZIGK.CFG /Zanthus/Zeus/path_comum_temp/GERALCFG/ZIGK.CFG
    echo \"$passwd\" | sudo -S rsync $rsync_options_local \"$WEBFILES/\" \"$DIRPDVJAVA\"
    echo \"$passwd\" | sudo -S ldconfig
    echo
    echo 'Atualização finalizada!'
    echo
"

    # Via SSH, faz configuração do timezone do sistema, usando a configuração da variável "localstate"

    # Timezone Modelo 1. Fazendo uso de multiplos comandos sudo
    # Chamando a função para executar os comandos via SSH
    #     executar_comando_ssh "
    #             echo -e '\nAnalisando versão do PDV...'
    #             cat /etc/canoalinux-release
    #             echo 'Configurando Timezone...'
    #             echo \"$passwd\" | sudo -S sed -i 's/UTC=no/UTC=yes/' /etc/default/rcS &>>/dev/null
    #             echo \"$passwd\" | sudo -S sed -i 's/NTPDATE_USE_NTP_CONF=no/NTPDATE_USE_NTP_CONF=yes/' /etc/default/ntpdate
    #             echo \"$passwd\" | sudo -S ln -sf /usr/share/zoneinfo/"$localstate" /etc/localtime
    #             echo \"$passwd\" | echo -e \"$localstate\" | sudo -S tee /etc/timezone >> /dev/null
    #             echo \"$passwd\" | sudo -S dpkg-reconfigure -f noninteractive tzdata
    #             echo \"$passwd\" | sudo -S hwclock -w
    #             echo \"$passwd\" | sudo -S timedatectl set-local-rtc 0
    #             echo \"$passwd\" | sudo -S timedatectl set-ntp 1
    #             echo \"$passwd\" | sudo -S timedatectl set-timezone  \"$localstate\"
    #             echo \"$passwd\" | sudo -S ntpdate a.ntp.br b.ntp.br c.ntp.br
    #             echo \"$passwd\" | sudo -S hwclock -w
    #             timedatectl
    #             echo 'Hora atual do PDV:'
    #             date
    #             echo 'Configuração do Timezone finalizada!'
    #             echo ' '
    # "

    # Timezone Modelo 2. Fazendo uso de de <<EOF
    # Substitui os múltiplos comandos {echo "$passwd" | sudo -S} por um bloco único usando {sudo -S bash <<EOF}.
    # Isso permite que execute múltiplos comandos com sudo de uma vez, o que torna o código mais limpo e eficiente.
    # Além disso, isso evita a repetição do comando {echo "$passwd" | sudo -S} várias vezes.
    # Chamando a função para executar os comandos via SSH
    #     executar_comando_ssh "
    #         echo -e '\nAnalisando versão do PDV...'
    #         cat /etc/canoalinux-release
    #         echo 'Configurando Timezone...'

    #         # Usando sudo uma vez para todos os comandos
    #         echo \"$passwd\" | sudo -S bash <<EOF
    #         sed -i 's/UTC=no/UTC=yes/' /etc/default/rcS
    #         sed -i 's/NTPDATE_USE_NTP_CONF=no/NTPDATE_USE_NTP_CONF=yes/' /etc/default/ntpdate
    #         ln -sf /usr/share/zoneinfo/$localstate /etc/localtime
    #         echo -e \"$localstate\" | tee /etc/timezone > /dev/null
    #         dpkg-reconfigure -f noninteractive tzdata
    #         hwclock -w
    #         timedatectl set-local-rtc 0
    #         timedatectl set-ntp 1
    #         timedatectl set-timezone \"$localstate\"
    #         ntpdate a.ntp.br b.ntp.br c.ntp.br
    #         hwclock -w
    # EOF

    #         # Exibindo as configurações finais
    #         timedatectl
    #         echo 'Hora atual do PDV:'
    #         date
    #         echo 'Configuração do Timezone finalizada!'
    #         echo ' '
    # "

done

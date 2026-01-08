#!/bin/bash
#
# ============================================================
# Script: pdv-usermodpw.sh
#
# Objetivo:
#   Este script automatiza a criação e atualização de usuários
#   no sistema Linux. Ele lê um arquivo texto contendo usuários
#   e senhas, verifica se cada usuário já existe e:
#     - Se existir: atualiza a senha e garante que esteja no grupo sudo.
#     - Se não existir: cria o usuário, define a senha e adiciona ao grupo sudo.
#
# Como usar:
#   1. Crie um arquivo chamado "pdv-usermodpw.txt" no mesmo diretório do script.
#   2. Cada linha do arquivo deve conter o usuário e a senha separados por dois pontos:
#        usuario:senha
#
#      Exemplo de pdv-usermodpw.txt:
#        usuario1:Senha1
#        usuario2:Senha2
#        usuario3:Senha3
#
#   3. Dê permissão de execução ao script:
#        chmod +x pdv-usermodpw.sh
#
#   4. Execute o script:
#        ./pdv-usermodpw.sh
#
# Observações:
#   - O script precisa ser executado com privilégios administrativos
#     (usuário root ou via sudo), pois cria usuários e altera senhas.
#   - Linhas vazias ou iniciadas com "#" no arquivo pdv-usermodpw.txt serão ignoradas.
#   - As senhas ficam em texto puro no arquivo pdv-usermodpw.txt. Para maior segurança,
#     considere usar hashes ou outro método de gerenciamento de credenciais.
#
# ============================================================
#
#   Automatizar a configuração da senha do x11vnc.
#   O script lê a senha do arquivo "pdv-usermodpw-x11vnc.txt" e grava
#   diretamente no arquivo /root/.vncpasswd sem interação.
#
# Como usar:
#   1. Crie um arquivo chamado "pdv-usermodpw-x11vnc.txt" no mesmo diretório do script.
#   2. Dentro dele, coloque apenas a senha desejada para o x11vnc.
#
#      Exemplo de pdv-usermodpw-x11vnc.txt:
#        MinhaSenhaSecreta
#
# Observações:
#   - O arquivo /root/.vncpasswd será sobrescrito com a nova senha.
#   - O script precisa ser executado com privilégios administrativos.
#   - A senha fica em texto puro dentro de pdv-usermodpw-x11vnc.txt, considere
#     proteger esse arquivo (permissões restritas).
# ============================================================

# Arquivo com usuários e senhas (formato: usuario:senha)
ARQUIVO_USUARIOS="pdv-usermodpw.txt"


# Arquivo com senha para o VNC
ATUALIZA_SENHA_VNC=1	# Atualizar senha VNC? 1 para "SIM", 0 para "NÃO"
ARQUIVO_SENHAVNC="pdv-usermodpw-x11vnc.txt"
DESTINO_VNCPWD="/root/.vncpasswd"

# Função para verificar/criar usuário e adicionar ao grupo sudo
verificar_usuario() {
    USUARIO=$1
    SENHA=$2
    if id "$USUARIO" &>/dev/null; then
        echo "Usuário $USUARIO já existe."
        # Verificar se está no grupo sudo
        if groups "$USUARIO" | grep -q "\bsudo\b"; then
            echo "Usuário $USUARIO já está no grupo sudo."
        else
            sudo usermod -aG sudo "$USUARIO"
            echo "Usuário $USUARIO adicionado ao grupo sudo."
        fi
        # Atualizar senha mesmo se já existir
        echo "$USUARIO:$SENHA" | sudo chpasswd
        echo "Senha do usuário $USUARIO atualizada."
    else
        echo "Usuário $USUARIO não existe. Criando..."
        sudo useradd -m -s /bin/bash "$USUARIO"
        echo "$USUARIO:$SENHA" | sudo chpasswd
        sudo usermod -aG sudo "$USUARIO"
        echo "Usuário $USUARIO criado, senha definida e adicionado ao grupo sudo."
    fi
}

# Ler o arquivo linha por linha
while IFS=":" read -r usuario senha; do
    # Ignorar linhas vazias ou comentários
    [[ -z "$usuario" || "$usuario" =~ ^# ]] && continue
    verificar_usuario "$usuario" "$senha"
done < "$ARQUIVO_USUARIOS"

echo "Processo de atualização de usuários concluído!"

###

if [[ -f "$ARQUIVO_SENHAVNC" && $ATUALIZA_SENHA_VNC -eq 1 ]]; then
    SENHA_VNC=$(grep -v '^\s*$' "$ARQUIVO_SENHAVNC" | head -n 1)
    if [[ -n "$SENHA_VNC" ]]; then
        echo "$SENHA" | sudo -S x11vnc -storepasswd "$SENHA_VNC" "$DESTINO_VNCPWD"
        echo "Senha do VNC atualizada em $DESTINO_VNCPWD."
    else
        echo "Arquivo $ARQUIVO_SENHAVNC está vazio, senha do VNC não atualizada."
    fi
fi

rm -rf "$ARQUIVO_USUARIOS" &>>/dev/null
rm -rf "$ARQUIVO_SENHAVNC" &>>/dev/null

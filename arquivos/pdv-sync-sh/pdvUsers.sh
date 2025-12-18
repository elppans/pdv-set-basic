#!/bin/bash

# Senhas individuais
SENHA_ZANTHUS="upvJ;<]=77o2:"
SENHA_PDVTEC="SenhaPdvtec123!"
SENHA_SUSTENTACAO="SenhaSustentacao456!"

# Função para alterar senha de um usuário
alterar_senha() {
    echo "$1:$2" | sudo chpasswd
    echo "Senha do usuário $1 alterada."
}

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

# 1) Alterar senha do usuário zanthus
alterar_senha "zanthus" "$SENHA_ZANTHUS"

# 2) Verificar/criar usuários pdvtec e sustentacao
verificar_usuario "pdvtec" "$SENHA_PDVTEC"
verificar_usuario "sustentacao" "$SENHA_SUSTENTACAO"

echo "Processo concluído!"


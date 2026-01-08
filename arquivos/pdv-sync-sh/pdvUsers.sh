#!/bin/bash
#
# ============================================================
# Script: pdvUsers.sh
#
# Objetivo:
#   Este script automatiza a criação e atualização de usuários
#   no sistema Linux. Ele lê um arquivo texto contendo usuários
#   e senhas, verifica se cada usuário já existe e:
#     - Se existir: atualiza a senha e garante que esteja no grupo sudo.
#     - Se não existir: cria o usuário, define a senha e adiciona ao grupo sudo.
#
# Como usar:
#   1. Crie um arquivo chamado "pdvUsers.txt" no mesmo diretório do script.
#   2. Cada linha do arquivo deve conter o usuário e a senha separados por dois pontos:
#        usuario:senha
#
#      Exemplo de pdvUsers.txt:
#        usuario1:Senha1
#        usuario2:Senha2
#        usuario3:Senha3
#
#   3. Dê permissão de execução ao script:
#        chmod +x pdvUsers.sh
#
#   4. Execute o script:
#        ./pdvUsers.sh
#
# Observações:
#   - O script precisa ser executado com privilégios administrativos
#     (usuário root ou via sudo), pois cria usuários e altera senhas.
#   - Linhas vazias ou iniciadas com "#" no arquivo pdvUsers.txt serão ignoradas.
#   - As senhas ficam em texto puro no arquivo pdvUsers.txt. Para maior segurança,
#     considere usar hashes ou outro método de gerenciamento de credenciais.
#
# ============================================================


# Arquivo com usuários e senhas (formato: usuario:senha)
ARQUIVO_USUARIOS="pdvUsers.txt"

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

echo "Processo conclu && continue
    verificar_usuario "$usuario" "$senha"
done < "$ARQUIVO_USUARIOS"

echo "Processo concluído!"

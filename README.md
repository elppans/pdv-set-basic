# pdv-sync

Após baixar:

- Crie o diretório "**.ip**" em seu **$HOME**

```bash
mkdir -p "$HOME/.ip"
```

- Crie um arquivo com o nome **ip.txt** no diretório "**$HOME/.ip**"

```bash
touch "$HOME/.ip/ip.txt"
```
- Edite e adicione os IPs no arquivo ip.txt como uma lista, linha por linha. Exemplo:

```ini
192.168.15.95
192.168.15.96
192.168.15.97
```
- Crie um diretório, `$HOME/.pdv-sync/` e dentro, o arquivo `usr.ini` e `pwd.ini`.
>Mais detalhes no item "Diretório e arquivos de configuração"
___
- **OPCIONAL**. Faça um teste de comunicação
```bash
./pdv-set_ping.sh
```
___
- Execute o update

>O teste de comunicação foi incluído no Script de atualização,  
>Antes do trabalho de atualização, será executado o teste de comunicação.

```bash
./pdv-set_update.sh
```
## Diretório e arquivos de configuração

1. Criar o diretório base:
```bash
mkdir -p $HOME/.pdv-sync
```
2. Dentro desse diretório, criar dois arquivos:

- usr.ini → lista de usuários (um por linha)
Exemplo:

```ini
usuario1
usuario2
usuario3
```

- pwd.ini → lista de senhas correspondentes (uma por linha)
Exemplo:

```ini
senha1
senha2
senha3
```

>Observação:
>>- Cada linha de usr.ini corresponde à mesma linha de pwd.ini.
>>Ou seja, primeira linha de usr.ini usa a primeira linha de pwd.ini.
>>- Linhas vazias são ignoradas.

3. Como usar:
- O script lê automaticamente os arquivos usr.ini e pwd.ini.
- Ele testa as combinações de usuário e senha contra o IP configurado.
- Quando encontra uma combinação válida, exporta as variáveis:
```ini
user   → usuário válido
passwd → senha correspondente
```
- Essas variáveis são usadas pelas próximas funções do script.
___

- **Nota:**  
A característica dos arquivos .ini etá em teste no Script `pdv-set_update-apw.sh`
___

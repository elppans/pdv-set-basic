# pdv-set-basic

Após baixar:

- Crie o diretório ".ip" em seu $HOME

```bash
mkdir -p "$HOME/.ip"
```

- Crie um arquivo com o nome `**ip.txt**` no diretório "$HOME"

```bash
touch "$HOME/.ip"
```
- Edite e adicione os IPs no arquivo ip.txt como uma lista, linha por linha. Exemplo:

```ini
192.168.15.95
192.168.15.96
192.168.15.97
```

- **OPCIONAL**. Faça um teste de comunicação
```bash
./pdv-set_ping.sh
```

- Execute o update
>O teste de comunicação foi incluído no Script de atualização,  
>Antes do trabalho de atualização, será executado o teste de comunicação.

```bash
./pdv-set_update-pdvJava.sh
```

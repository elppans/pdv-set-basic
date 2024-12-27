# pdv-set-basic

Após baixar:

- Crie o diretório ".ip" em seu $HOME

```bash
mkdir -p "$HOME/.ip"
```

- Copie o arquivo ip.txt para o diretório

```bash
cp ip.txt "$HOME/.ip"
```
- Adicione os IPs no arquivo ip.txt como uma lista, linha por linha. Exemplo:

```ini
192.168.15.95
192.168.15.96
192.168.15.97
```

- Faça um teste de comunicação
```bash
./pdv-set_ping.sh
```

- Por fim execute o update
```bash
./pdv-set_update-pdvJava.sh
```

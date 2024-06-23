# Команда для установки
https://raw.githubusercontent.com/g7AzaZLO/nubit_auto_installer/main/nubit_auto_installer.sh

# Просмотр статистики по ноде(все ли окей)
docker exec <container_id_or_name> $HOME/nubit-node/bin/nubit das sampling-stats --node.store $HOME/.nubit-light-nubit-alphatestnet-1

# Просмотр адреса
docker exec <container_id_or_name> $HOME/nubit-node/bin/nkey list --p2p.network nubit-alphatestnet-1 --node.type light

# Просмотр мнемоники
docker exec <container_id_or_name> cat $HOME/nubit-node/mnemonic.txt

# Удаление ноды
docker stop <container_id_or_name>
docker rm <container_id_or_name>
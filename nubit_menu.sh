#!/bin/bash
echo -e "\033[1;36m"
echo -e "████╗░██████╗░███████╗████╗  ░█████╗░███████╗░█████╗░███████╗██╗░░░░░░█████╗░"
echo -e "██╔═╝██╔════╝░╚════██║╚═██║  ██╔══██╗╚════██║██╔══██╗╚════██║██║░░░░░██╔══██╗"
echo -e "██║░░██║░░██╗░░░░░██╔╝░░██║  ███████║░░███╔═╝███████║░░███╔═╝██║░░░░░██║░░██║"
echo -e "██║░░██║░░╚██╗░░░██╔╝░░░██║  ██╔══██║██╔══╝░░██╔══██║██╔══╝░░██║░░░░░██║░░██║"
echo -e "████╗╚██████╔╝░░██╔╝░░████║  ██║░░██║███████╗██║░░██║███████╗███████╗╚█████╔╝"
echo -e "╚═══╝░╚═════╝░░░╚═╝░░░╚═══╝  ╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚══════╝╚══════╝░╚════╝░"
echo -e "\033[1;34m"
echo
echo -e "\033[1;32mTelegram community: \033[5;31mhttps://t.me/g7monitor\033[0m"
echo -e "\033[0m"

# Function to display menu and choose the container
choose_container() {
    echo "Choose the container to perform operations:"

    # Get list of containers with image name nubit
    containers=$(docker ps -a --filter "ancestor=nubit" --format "{{.ID}}")

    if [ -z "$containers" ]; then
        echo "No active containers found with image 'nubit'."
        exit 1
    fi

    # Display list of containers
    echo "$containers"

    # Ask user to choose a container
    read -p "Enter the ID or name of the container from the list above: " container_id_or_name
    echo

    # Check if the entered container exists
    if docker inspect "$container_id_or_name" >/dev/null 2>&1; then
        CONTAINER_ID_OR_NAME="$container_id_or_name"
    else
        echo "Container with ID or name '$container_id_or_name' not found."
        exit 1
    fi
}

# Function to execute the sampling stats command
get_sampling_stats() {
    docker exec $CONTAINER_ID_OR_NAME $HOME/nubit-node/bin/nubit das sampling-stats --node.store $HOME/.nubit-light-nubit-alphatestnet-1
}

# Function to execute the address and pubkey command
get_address_and_pubkey() {
    docker exec $CONTAINER_ID_OR_NAME $HOME/nubit-node/bin/nkey list --p2p.network nubit-alphatestnet-1 --node.type light
}

# Function to execute the mnemonic phrase command
get_mnemonic_phrase() {
    docker exec $CONTAINER_ID_OR_NAME cat $HOME/nubit-node/mnemonic.txt
}

# Function to execute the delete node command
delete_node() {
    echo "Are you sure you want to delete the node? This action will permanently delete data."
    read -p "Enter 'yes' to confirm: " confirm
    echo

    if [ "$confirm" = "yes" ]; then
        docker exec $CONTAINER_ID_OR_NAME rm -rf $HOME/nubit-node
        docker exec $CONTAINER_ID_OR_NAME rm -rf $HOME/.nubit-light-nubit-alphatestnet-1
        echo "Node successfully deleted."
    else
        echo "Deletion canceled."
    fi
}

# Function to track container logs
track_container_logs() {
    docker logs -f --tail 10 $CONTAINER_ID_OR_NAME
}

# Function to display menu and perform actions
show_menu() {
    echo "Select an action:"
    echo "1. View sampling statistics"
    echo "2. View address and pubkey"
    echo "3. View mnemonic phrase"
    echo "4. Delete node (irreversible operation)"
    echo "5. Track container logs"
    echo "6. Exit"

    read -p "Enter the action number: " choice
    echo

    case $choice in
        1) get_sampling_stats ;;
        2) get_address_and_pubkey ;;
        3) get_mnemonic_phrase ;;
        4) delete_node ;;
        5) track_container_logs ;;
        6) exit ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
}

# Main script

choose_container

while true; do
    show_menu
    echo
done

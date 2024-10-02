#!/bin/bash

set -xe

wallet_name="test_wallet"
address_label="myaddress"

# first getwalletinfo to check if wallet exists, if not create it and then get the address
# if wallet exists, get the address
get_wallet_info=$(curl -s --data-binary '{"jsonrpc":"1.0","id":"1","method":"getwalletinfo"}' http://$1:$2@$3:18443/)
result=$(jq -r '.result' <<<$get_wallet_info)
address=""
if [ "$result" == "null" ]; then
    echo "try to load wallet ....."
    load_info=$(curl -s --data-binary '{"jsonrpc":"1.0","id":"1","method":"loadwallet","params":["'$wallet_name'"]}' http://$1:$2@$3:18443/)
    result=$(jq -r '.result' <<<$load_info)
    if [ "$result" == "null" ]; then
        echo "Error loading wallet, now create wallet ....."
        creat_info=$(curl -s --data-binary '{"jsonrpc":"1.0","id":"1","method":"createwallet","params":["'$wallet_name'"]}' http://$1:$2@$3:18443/)
        create_err=$(jq -r '.error' <<<$creat_info)
        if [ "$create_err" != "null" ]; then
            echo "Error creating wallet"
            exit 1
        fi

        echo "generating new address ....."
        address=$(jq -r '.result' <<<$(curl -s --data-binary '{"jsonrpc":"1.0","id":"1","method":"getnewaddress","params":["'$address_label'"]}' http://$1:$2@$3:18443/))
        if [ "$address" == "null" ]; then
            echo "Error getting new address"
            exit 1
        fi
    fi
fi

if [ "$address" == "" ]; then
    echo "get address ....."
    addresses=$(curl -s --data-binary '{"jsonrpc":"1.0","id":"1","method":"getaddressesbylabel","params":["'$address_label'"]}' http://$1:$2@$3:18443/wallet/$wallet_name)
    addr_err=$(jq -r '.error' <<<$addresses)
    if [ "$addr_err" != "null" ]; then
        echo "Error getting address"
        exit 1
    fi
    address=$(jq -r '.result | keys[0]' <<<$addresses)
fi

echo "Myaddress $address ...."
if [ "$address" == "null" ]; then
    echo "Error getting address"
    exit 1
fi

echo "Generating a block every minute. Press [CTRL+C] to stop.."

while :; do
    echo "Generate a new block $(date '+%d/%m/%Y %H:%M:%S')"
    curl -s --data-binary '{"jsonrpc":"1.0","id":"1","method":"generatetoaddress","params":[1,"'$address'"]}' http://$1:$2@$3:18443/
    sleep 4
done

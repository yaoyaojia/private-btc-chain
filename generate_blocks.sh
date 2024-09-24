# Script to generate a new block
# Put this script at the root of your unpacked folder
#!/bin/bash

echo "create wallet ....."

bitcoin-cli -chain=regtest -rpcuser=$1 -rpcpassword=$2 -rpcconnect=$3 createwallet test_wallet

echo "Generating a block every minute. Press [CTRL+C] to stop.."

address=`bitcoin-cli -chain=regtest -rpcuser=$1 -rpcpassword=$2 -rpcconnect=$3 getnewaddress`

while :
do
        echo "Generate a new block `date '+%d/%m/%Y %H:%M:%S'`"
        bitcoin-cli -chain=regtest -rpcuser=$1 -rpcpassword=$2 -rpcconnect=$3 generatetoaddress 1 $address
        sleep 4
done

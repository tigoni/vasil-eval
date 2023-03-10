#!/bin/bash

oref=$1
amt=$2
tokenName=$3
addrFile=$4
skeyFile=$5

rootDir=../af/mint
echo "oref: $oref"
echo "amt: $amt"
echo "tokenName: $tokenName"
echo "address file: $addrFile"
echo "signing key file: $skeyFile"

protocolParams=$rootDir/protocol-params.json
cardano-cli query protocol-parameters --$TS --out-file $protocolParams

#create a serialised file from the script
serializedPolicyScriptFile=$rootDir/dynasty-baya.plutus
cabal exec token-policy $serializedPolicyScriptFile $oref $amt $tokenName

unsignedFile=$rootDir/tx.unsigned
signedFile=$rootDir/tx.signed

#Get the policy id (will uniquely identify the token assets)
policyId=$(cardano-cli transaction policyid --script-file $serializedPolicyScriptFile)
tokenNameHex=$(cabal exec token-name-hex -- $tokenName)
address=$(cat $addrFile)
value="$amt $policyId.$tokenNameHex"

echo "currency symbol: $policyId"
echo "token name (hex): $tokenNameHex"
echo "minted value: $value"
echo "address: $address"

cardano-cli transaction build \
    --babbage-era \
    --tx-in $oref \
    --tx-in-collateral $oref \
    --tx-out "$address 10000000 lovelace + $value" \
    --mint "$value" \
    --mint-script-file $serializedPolicyScriptFile \
    --mint-redeemer-file $rootDir/unit.json \
    --metadata-json-file $rootDir/metadata.json \
    --change-address $(cat ../wallets/minter/minter.addr) \
    --protocol-params-file $protocolParams \
    --out-file $unsignedFile  \
    --$TS  

cardano-cli transaction sign \
    --tx-body-file $unsignedFile \
    --signing-key-file $skeyFile \
    --$TS \
    --out-file $signedFile

cardano-cli transaction submit \
    --$TS \
    --tx-file $signedFile

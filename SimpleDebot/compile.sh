#!/bin/bash
set -e

tondev sol compile purchaseList.sol
tondev sol compile purchaseListDebot.sol
tondev sol compile purchaseBuyDebot.sol
tonos-cli decode stateinit purchaseList.tvc --tvc > purchaseList.decode.json 

echo "Compiled"
echo "Compiled"
echo "Compiled"
echo "Compiled"


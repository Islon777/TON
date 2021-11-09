echo "Run deploying scripts\npurchaseList Debot"
./deploy_debot_devnet.sh purchaseListDebot.tvc | tee Addresses.log
Add_DEBOT_ADDRESS=$(cat Addresses.log | grep "Done!" | cut -d ' ' -f 6)

echo "purchaseBuy Debot"
./deploy_debot_devnet.sh purchaseBuyDebot.tvc | tee Addresses.log
Buy_DEBOT_ADDRESS=$(cat Addresses.log | grep "Done!" | cut -d ' ' -f 6)

echo "All done! Debot addresses:"
echo "purchaseList: $Add_DEBOT_ADDRESS"
echo "purchaseBuy: $Buy_DEBOT_ADDRESS"
read -p 'Exit? ' inputvar
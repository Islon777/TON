# How to run
Some instructions to simplify deploying and testing process.

### Compile
`compile.sh` compiles contract and 2 debots, saves stateInit of contract.
```
./compile.sh
```
Then manually edit purchaseList.decode.json file to make valid json file.

### Deploy on SE
`deploy_local.sh` deploys debots on SE with help `deploy_debot.sh`
```
./deploy_local.sh
```

### Deploy Devnet
`deploy_devnet.sh` deploys debots on http://net.ton.dev. with help `deploy_debot_devnet.sh`
While executing the script, you will need to manually send tons to the addresses of DeBots.

### Addresses of deployed deBots
Address of purchaseListDebot:
`0:324d08a5a4c0273a610c7ee8a69588d4ea491b743ec0b96155fcb3fd08a810c6`
link: https://web.ton.surf/debot?address=0%3A324d08a5a4c0273a610c7ee8a69588d4ea491b743ec0b96155fcb3fd08a810c6&net=devnet&restart=true

Address of purchaseBuyDebot:
`0:1bebbfba8d9931bf8f8126e85eb839eab386e00d49854e9d636b232f692eaa5c`
link: https://web.ton.surf/debot?address=0%3A1bebbfba8d9931bf8f8126e85eb839eab386e00d49854e9d636b232f692eaa5c&net=devnet&restart=true

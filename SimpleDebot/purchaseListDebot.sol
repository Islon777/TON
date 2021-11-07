pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "./debots/InitializationDebot.sol";


contract purchaseList is InitializationDebot {

    PurchaseSummary m_stat;        


    function createPurchaseDebot(uint32 index) public override{
        index = index;
        string name;
        unit32 count;
        name = Terminal.input(0, "Purchase name please:", false);
        count = Terminal.input(0, "Enter required quantity:", false);
        createPurchase_(name, count);
    }

    function createPurchase_(string name, unit32 count) public view {
        optional(uint256) pubkey = 0;
        IntShopList(m_address).createPurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(name, count);
    }
}

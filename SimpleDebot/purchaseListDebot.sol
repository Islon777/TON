pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "./debots/InitializationDebot.sol";

contract purchaseListDebot is InitializationDebot {

    string m_name;

    function _menu() internal override {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {}/{}/{} (paid/unpaid/total) items in your purchase list. Total amount paid: {}",
                    m_stat.paid,
                    m_stat.unpaid,
                    m_stat.paid + m_stat.unpaid,
                    m_stat.totalSum
            ),
            sep,
            [
                MenuItem("Create purchase","",tvm.functionId(requestItemName)),
                MenuItem("Show purchase list","",tvm.functionId(showList)),
                MenuItem("Delete purchase","",tvm.functionId(deleteRecord))
            ]
        );
    }

    function requestItemName(uint32 index) public {
        index = index; 
        Terminal.input(tvm.functionId(storeItemName), "Item name please:", false);
    }

    function storeItemName(string value) public {
        m_name = value;
        Terminal.input(tvm.functionId(createPurchase_), "Enter required quantity:", false);
    }

    function createPurchase_(string value) public{
        (uint res, bool status) = stoi(value);
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
        }(m_name, uint32(res));      
    }


    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "ShopList DeBot";
        version = "0.1.0";
        publisher = "Islon Company";
        key = "Shop list manager";
        author = "Islon";
        support = address.makeAddrStd(0, 0x66e01d6df5a8d7677d9ab2daf7f258f1e2a7fe73da5320300395f99e01dc3b5f);
        hello = "Hi, i'm a shopList DeBot.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = m_icon;
    }
}





pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "./debots/InitializationDebot.sol";


contract purchaseList is InitializationDebot {

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
                MenuItem("Create purchase","",tvm.functionId(createItemName)),
                MenuItem("Show purchase list","",tvm.functionId(showList)),
                MenuItem("Delete purchase","",tvm.functionId(deleteRecord))
            ]
        );
    }

    function createItemName(uint32 index) public {
        index = index; 
        Terminal.input(tvm.functionId(saveItemName), "Item name please:", false);
    }

    function saveItemName(string name) public {
        m_name = name;
        Terminal.input(tvm.functionId(createPurchase_), "Enter required quantity:", false);
    }

    function createPurchase_(string quantity) public {
        (uint res, bool status) = stoi(quantity);
        uint32 count = uint32(res);
        optional(uint256) pubkey = 0;
        if (status) {
            IntShopList(m_address).createPurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(m_name, count);
        } else {
            Terminal.input(tvm.functionId(createPurchase_), "Wrong symbols. Enter required quantity:", false);
        }
        
    }
}





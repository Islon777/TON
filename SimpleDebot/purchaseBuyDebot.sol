pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "./debots/InitializationDebot.sol";

contract purchaseBuyDebot is InitializationDebot {

    uint32 m_itemId;
    uint32 m_sum;

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
                MenuItem("Pay purchase","",tvm.functionId(payItem)),
                MenuItem("Show purchase list","",tvm.functionId(showList)),
                MenuItem("Delete purchase","",tvm.functionId(deleteRecord))
            ]
        );
    }

    function payItem(uint32 index) public {
        index = index;
        if (m_stat.paid + m_stat.unpaid > 0) {
            Terminal.input(tvm.functionId(payItem_), "Enter purchase number:", false);
        } else {
            Terminal.print(0, "Sorry, you have no items to pay");
            _menu();
        }
    }

    function payItem_(string value) public {
        (uint256 num,) = stoi(value);
        m_itemId = uint32(num);
        Terminal.input(tvm.functionId(pay_),"Please enter total sum of purchase",false);
    }


    function pay_(string value) public {
        (uint256 num,) = stoi(value);
        m_sum = uint32(num);
        optional(uint256) pubkey = 0;
        IntShopList(m_address).payPurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(m_itemId, m_sum);
    }


    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Purchases Pay DeBot";
        version = "0.1.0";
        publisher = "Islon Company";
        key = "Purchases payment manager";
        author = "Islon";
        support = address.makeAddrStd(0, 0x66e01d6df5a8d7677d9ab2daf7f258f1e2a7fe73da5320300395f99e01dc3b5f);
        hello = "Hi, i'm a Purchases Pay DeBot.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = m_icon;
    }
}





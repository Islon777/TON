pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "./interfaces/structs.sol";

contract shopList {
    /*
     * ERROR CODES
     * 100 - Unauthorized
     * 102 - purchase not found
     */

    uint256 m_ownerPubkey;

    constructor( uint256 pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }

    
    modifier onlyOwner() {
        require(msg.pubkey() == m_ownerPubkey, 101);
        _;
    }

    uint32 m_count;

    mapping(uint32 => Purchase)  m_buyList;   
    

    function createPurchase(string name, uint32 count) public onlyOwner {
        tvm.accept();
        m_count++;
        m_buyList[m_count] = Purchase(m_count, name, count, now, false, 0);
    }


    function deletePurchase(uint32 id) public onlyOwner {
        require(m_buyList.exists(id), 102);
        tvm.accept();
        delete m_buyList[id];
    }


    function payPurchase(uint32 id, uint32 sum) public onlyOwner {
        optional(Purchase) buy = m_buyList.fetch(id);
        require(buy.hasValue(), 102);
        tvm.accept();
        m_buyList[id].isBought = true;
        m_buyList[id].sum = sum;
    }    


    function getPurchases() public view returns (Purchase[] purchases) {
        
        for((uint32 id, Purchase buy) : m_buyList) {
            purchases.push(buy);
       }
    }


    function getStat() public view returns (PurchaseSummary buysSummary) {
        uint32 paid;                  
        uint32 unpaid;       
        uint64 totalSum;

        for((, Purchase buy) : m_buyList) {
            if  (buy.isBought) {
                paid += buy.count;
                totalSum += buy.sum;
            } else {
                unpaid += buy.count;
            }
        }
        buysSummary = PurchaseSummary(paid, unpaid, totalSum);
    }
}


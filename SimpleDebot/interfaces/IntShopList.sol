pragma ton-solidity >=0.35.0;

import"structs.sol";

interface IntShopList {
   function createPurchase(string name, uint32 count) external;
   function payPurchase(uint32 id, uint32 sum) external;
   function deletePurchase(uint32 id) external;
   function getPurchases() external returns (Purchase[] purchases);
   function getStat() external returns (PurchaseSummary) ;
}

pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObj.sol";
import "MilitaryInt.sol";

contract Base is GameObj {
   
    uint private AP = 200;


    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        HP = 200;
        param.armor = AP;
        param.health = HP;
        tvm.accept();
    }

    mapping(address => MilitaryInt) public milList; // т.к. KeyType не может быть объектом интерфейса (только контракта), 
                                                    // сделана такая товтология

    // Get Armor Points 
    function getArmor(uint _AP) virtual public override returns (uint Armor){
        require(msg.pubkey() == tvm.pubkey(), 102);
        param.armor = AP + _AP;
        AP = param.armor;
        tvm.accept();
        return param.armor;
    }

    function addMilitaryUnit () external {
        address milAddr = msg.sender;
        milList[milAddr] = MilitaryInt(milAddr);  
    }

    function delMilitaryUnit () external {
        address milAddr = msg.sender;
        if (milList.exists(milAddr)){
            delete milList[milAddr];
        }           
    }

    // Dead processing
    function ifKilled(address dest) virtual internal override {       
        for ((address key, MilitaryInt value):milList){
           value.BaseFall(dest);
        }
        selfDestroy(dest);
    }
}
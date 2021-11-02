
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObj.sol";
import "GameObjInt.sol";
import "Base.sol";  
import "MilitaryInt.sol";


contract MilitaryUnit is GameObj, MilitaryInt {
   
    
    Base employer;
    constructor(Base base_address) public {
        base_address.addMilitaryUnit();
        employer = base_address;
        tvm.accept();
    }

    // Attack the enemy
    function attack (GameObjInt aim_address) public {
        require(msg.pubkey() == tvm.pubkey(), 102);
        aim_address.acceptAttack(param.power);
        tvm.accept();
    }

    // Get Power points
    function getPower(uint _PP) virtual public returns (uint) {
        
    }
    // Get Armor Points 
    function getArmor(uint _AP) virtual public override returns (uint){
    }

    // Dead processing
    function ifKilled(address dest) virtual internal override{       
        selfDestroy(dest);
        employer.delMilitaryUnit();
        tvm.accept();
    }
    
    // Dead if Base is fall
    function BaseFall(address dest) external override {
        require(msg.sender == employer, 115, "Только Родная База может уничтожать военных");
        selfDestroy(dest);
        tvm.accept();
    }
}
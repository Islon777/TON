
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "MilitaryUnit.sol"; 
import "Base.sol";

contract Archer is MilitaryUnit {
    
    uint private AP = 80;
    uint private PP = 55;
    //Params param = Params(HP, AP, PP);
    constructor(Base base_address) MilitaryUnit(base_address)  public {
        param.armor = AP;
        HP = 100;
        param.health = HP;
        param.power = PP;
        tvm.accept();
    }

   // Get Power points
    function getPower (uint _PP) virtual public override returns (uint Power){
        require(msg.pubkey() == tvm.pubkey(), 102);
        param.power = PP + _PP;
        PP = param.power;
        tvm.accept();
        return param.power;
    }

    // Get Armor Points 
    function getArmor(uint _AP) virtual public override returns (uint Armor){
        require(msg.pubkey() == tvm.pubkey(), 102);
        param.armor = AP + _AP;
        AP = param.armor;
        tvm.accept();
        return param.armor;
    }

}
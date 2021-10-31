
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObj.sol";
// import "MilitaryUnit.sol";
contract Base is GameObj {
   
    uint militarists = 0;
    uint private AP = 200;


    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        HP = 200;
        param.armor = AP;
        param.health = HP;
        tvm.accept();
    }

    mapping(address => uint) public milList;

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
        militarists +=1;
        milList[milAddr] = militarists;   
    }

    function delMilitaryUnit () external {
        address milAddr = msg.sender;
        if (milList.exists(milAddr)){
            delete milList[milAddr];
            militarists -= 1;
        }           
    }

    // Dead processing
    function ifKilled(address dest) virtual internal override{       
        // for ((address key, uint value):milList){
        //    MilitaryUnit unit = MilitaryUnit(key); // неполучается объявить объект MilitaryUnit из-за взаимного импорта, и как следствия "переопределения" контрактов в друг друге?
        //     key.BaseFall(dest);
        // }
        selfDestroy(dest);
    }
}
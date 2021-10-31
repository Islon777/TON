
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObjInt.sol"; // загружаем код интерфейса

// контракт является реализацией интерфейса storageInt
contract GameObj is GameObjInt {
    
    int HP;
    constructor () public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }
    struct Params {
        int health;
        uint armor;
        uint power;
    }

    Params public param;
    // Get Armor Points 
    function getArmor(uint _AP) virtual public returns (uint){
    }

        // Chek object's life status
    function isDead() public returns (bool status){
        param.health = HP;
        if (param.health <= 0) {
            status = true; // is dead
        } else {
            status = false; // is live
        }
        return status;
    }


    // Accept Attack (get damage)
    function acceptAttack(uint powerPoint) external override {
       address enemy_addr = msg.sender;
       if (powerPoint > param.armor) {
           param.health = HP - int256(powerPoint-param.armor); // отнять урон
           HP = param.health;
       }
       if (isDead()) {
           ifKilled(enemy_addr);
       }
       tvm.accept();
    }


    // Transfer all money and self-destroy
    function selfDestroy(address dest) internal {
        dest.transfer(0, true, 160); // transfer all money to winner and destroy yourself
        tvm.accept();
    }

    // Dead processing
    function ifKilled(address dest) virtual internal {
        selfDestroy(dest);
        tvm.accept();
    }
    
}

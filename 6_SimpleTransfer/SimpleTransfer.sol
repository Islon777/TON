
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

    /*
    6. Написать смарт-контракт Wallet. пример есть здесь: https://github.com/tonlabs/samples/blob/master/solidity/10_Wallet.sol
    Но расширить функционал следующими методами.
    - Отправить без оплаты комиссии за свой счет
    - Отправить с оплатой комисси за свой счет
    - Отправить все деньги и уничтожить кошелек
    */

contract SimpleTransfer {

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 112,"You aren't the wallet's owner!");
		tvm.accept();
		_;
	}
    // Function that send Value nanotons and fee is paid from value
    function sendAndGetterFee(address dest, uint128 value) public pure checkOwnerAndAccept {  
        dest.transfer(value, true, 0); // default bounce = true;
    }
    // Function that send Value nanotons and fee is paid from sender's wallet
    function sendAndSenderFee(address dest, uint128 value) public pure checkOwnerAndAccept {  
        dest.transfer(value, true, 1); // default bounce = true;
    }
    // Function that send all remaining tons and delete the wallet
    function sendAllAndDestroy(address dest) public pure checkOwnerAndAccept {  
        dest.transfer(0, true, 160); // default bounce = true;
    }
}


pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

    /*
    6. Написать смарт-контракт Wallet. пример есть здесь: https://github.com/tonlabs/samples/blob/master/solidity/10_Wallet.sol
    Но расширить функционал следующими методами.
    - Отправить без оплаты комиссии за свой счет
    - Отправить с оплатой комисси за свой счет
    - Отправить все деньги и уничтожить кошелек
    */

contract SimpleWallet {

    enum paymentMethod { GetterFee, SenderFee, AllandDestroy } // Параметр для управления функцией sendTransaction

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
/*
    modifier isValidPayType(paymentMethod payType) {
        require((uint8(payType) >= 0) && ((uint8(payType) <=2)), 107,"Invalid payment method");
		tvm.accept();
		_;
	}
*/
    /**
        @dev Sent tons to the destination adress with one of the several payment methods
        @param dest Transfer target address.
        @param value Nanotons value to transfer.
        @param payType Transfer method: 0 - Getter pays the fee
                                        1 - Sender pays the fee
                                        2 - Send all tons and destroy wallet
     */
    function sendTransaction(address dest, uint128 value, paymentMethod payType) public pure checkOwnerAndAccept {
        uint16 flag;
        if (payType == paymentMethod.GetterFee) {           // Проверка на неправильность payType не нужна
            flag = 0;                                       // т.к. компилятор сам проверяет число элементов enum при неявном uint8(payType)
        } else if (payType == paymentMethod.SenderFee) {
            flag = 1;
        } else if (payType == paymentMethod.AllandDestroy) {
            flag = 160;
        }
        dest.transfer(value, true, flag); // default bounce = true;
    }
}

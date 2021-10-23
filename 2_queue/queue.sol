
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

/*
    3.1. "Очередь в магазине"
        Хранилище данных - массив строк (Где строки имена людей, которые встают в очередь).
        Должны быть доступны опции:
                    встать в очередь (переданное имя встает в конец очереди - в конец массива)
                    вызвать следующего (первый из очереди уходит - нулевой элемент массива пропадает)

*/



contract queue {

    string[] public queueList;


    constructor() public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);

        tvm.accept();

    }

    // Modifier that allows to accept some external messages
	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    // Function that adds person name to the queueList
    function queue_add(string value) public checkOwnerAndAccept {
		queueList.push(value); 
	}

    // FIFO (First Input First Output)
    function queue_next() public checkOwnerAndAccept {
        require(!queueList.empty(),112);                 // массив не должен быть пуст, иначе нельзя оттуда что-то удалить
	    for (uint8 i = 0; i < queueList.length-1; i++) { // uint8 i - 8 бит достаточно для примера (от 0 до 255)
            queueList[i] = queueList[i+1];               // перезаписать на 1 позицию выше все элементы
        }
        queueList.pop();                        // удалить последний элемент, чтобы длина массива стала на 1 меньше
        // с версии 0.6 можно не писать array.length--
	}

    
}

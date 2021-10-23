

pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

/*
    5. Реализовать следующий функционал.
       Выпуск nft-токенов 
       У токена название + 1-5 свойств (свойства для нас не главное [в примере был power, у вас будут свои]).
        - в методе создания токена должна быть проверка на уникальность имени. Выпускать "одноименные" токены должно быть нельзя.
        - должна быть возвожность "выставить токен на продажу", то есть указать стоимость по которой токен продается. 
          Должно быть доступно толкьо владельцу
        - саму продажу пока НЕ осуществляем.
*/




contract SimpleToken {


    struct TokenSong {  // структура токена-песни (nft)
        string name;    // имя песни
        string author;  // автор
        uint size;      // размер файла в Mb
        uint sampleFreq;  // частота дискретизации kHz
    }

    mapping (string => uint) tokenToOwner; // id токена (название песни) => Id владельца (лицензиара) токена (песни)
    mapping (string => TokenSong) tokenList; // id токена (название песни) => информация о токене (песне)
    mapping (string => uint) tokenPrice; //id токена (название песни) => цена за токен

    TokenSong[] public tokenArr; // необязательный массив для отладки и проверки существующих токенов


    // Modifier that cheks owner
	modifier checkOwner (string tokenName) {
		require(msg.pubkey() == tokenToOwner[tokenName], 110);
		_;
	}
    // Modifier that cheks token name's uniqueness
    modifier checkUniqueness (string tokenName) {
		require(!tokenList.exists(tokenName), 112,'Token with that name already exist!');
        tvm.accept();
		_;
	}


    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    event forSale(uint tokenOwner, TokenSong tokenForSale, uint price); // событие-объявление о продаже токена

    function createToken(string name, string author, uint size, uint sampleFrec) public checkUniqueness (name) {
        tokenList[name] = TokenSong(name, author, size, sampleFrec); // добавление токена
        tokenToOwner[name] = msg.pubkey();                           // запись публичного ключа создателя в поле "владелец"

        tokenArr.push(tokenList[name]); 
    }
   
    function setForSale(string tokenName, uint price) public checkOwner (tokenName) {
        tokenPrice[tokenName] = price;
        tvm.accept();
        emit forSale(tokenToOwner[tokenName], tokenList[tokenName], price); // объявление/публикация продажи токена
    }


}

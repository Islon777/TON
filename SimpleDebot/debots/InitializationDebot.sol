pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

// Import of libraries
import "../libs/Debot.sol";
import "../libs/Terminal.sol";
import "../libs/AddressInput.sol";
import "../libs/ConfirmInput.sol";
import "../libs/Upgradable.sol";
import "../libs/Sdk.sol";
import "../libs/Menu.sol";

// Import of interfaces
import "../interfaces/structs.sol";
import "../interfaces/Transactable.sol";
import "../interfaces/IntShopList.sol";
import "../interfaces/HasConstructorWithPubkey.sol";




abstract contract InitializationDebot is Debot, Upgradable { 

    TvmCell m_shopListInitCode; // shopList contract code
    address m_address;  // shopList contract address
    PurchaseSummary m_stat;        // Statistics of purchases
    uint256 m_masterPubKey; // User pubkey
    address m_msigAddress;  // User wallet address

    uint32 INITIAL_BALANCE =  200000000;  // Initial shopList contract balance


    // Abstract funcions
    function _menu() internal virtual {}


    function setCode(TvmCell code, TvmCell data) public {
        require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();
        m_shopListInitCode = tvm.buildStateInit(code, data);
    }

    // Error processing functions
    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
        _menu();
    }

    function onSuccess() public view {
        _getStat(tvm.functionId(setStat));
    }
    

    function start() public override {
        Terminal.input(tvm.functionId(savePublicKey),"Please enter your public key",false);
    }

    /// @notice Returns Metadata about DeBot.
    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "ShopList DeBot";
        version = "0.1.0";
        publisher = "Islon Company";
        key = "Shop list manager";
        author = "Islon";
        support = address.makeAddrStd(0, 0x66e01d6df5a8d7677d9ab2daf7f258f1e2a7fe73da5320300395f99e01dc3b5f);
        hello = "Hi, i'm a shopList DeBot.";
        language = "en";
        dabi = m_debotAbi.get();
    }

    //function getRequiredInterfaces() public view virtual override returns (uint256[] interfaces) {}
        function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID, Menu.ID, AddressInput.ID, ConfirmInput.ID ];
    }



    function savePublicKey(string value) public {
        (uint res, bool status) = stoi("0x"+value);
        if (status) {
            m_masterPubKey = res;

            Terminal.print(0, "Checking if you already have a Shop list ...");
            TvmCell deployState = tvm.insertPubkey(m_shopListInitCode, m_masterPubKey);
            m_address = address.makeAddrStd(0, tvm.hash(deployState));
            Terminal.print(0, format( "Info: your ShopList contract address is {}", m_address));
            Sdk.getAccountType(tvm.functionId(checkContractStatus), m_address);

        } else {
            Terminal.input(tvm.functionId(savePublicKey),"Wrong public key. Try again!\nPlease enter your public key",false);
        }
    }


    function checkContractStatus(int8 acc_type) public {
        if (acc_type == 1) { // acc is active and  contract is already deployed
            _getStat(tvm.functionId(setStat));

        } else if (acc_type == -1)  { // acc is inactive
            Terminal.print(0, "You don't have a Shop list yet, so a new contract with an initial balance of 0.2 tokens will be deployed");
            AddressInput.get(tvm.functionId(creditAccount),"Select a wallet for payment. We will ask you to sign two transactions");

        } else  if (acc_type == 0) { // acc is uninitialized
            Terminal.print(0, format(
                "Deploying new contract. If an error occurs, check if your ShopList contract has enough tokens on its balance"
            ));
            deploy();

        } else if (acc_type == 2) {  // acc is frozen
            Terminal.print(0, format("Can not continue: account {} is frozen", m_address));
        }
    }


    function creditAccount(address value) public {
        m_msigAddress = value;
        optional(uint256) pubkey = 0;
        TvmCell empty;
        IMsig(m_msigAddress).sendTransaction{
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(waitBeforeDeploy),
            onErrorId: tvm.functionId(onErrorRepeatCredit)
        }(m_address, INITIAL_BALANCE, false, 3, empty);
    }

    function onErrorRepeatCredit(uint32 sdkError, uint32 exitCode) public {
        // TODO: check errors if needed.
        sdkError;
        exitCode;
        creditAccount(m_msigAddress);
    }


    function waitBeforeDeploy() public  {
        Sdk.getAccountType(tvm.functionId(checkIfNotDeployed), m_address);
    }

    function checkIfNotDeployed(int8 acc_type) public {
        if (acc_type ==  0) {
            deploy();
        } else {
            waitBeforeDeploy();
        }
    }


    function deploy() private view {
            TvmCell image = tvm.insertPubkey(m_shopListInitCode, m_masterPubKey);
            optional(uint256) none;
            TvmCell deployMsg = tvm.buildExtMsg({
                abiVer: 2,
                dest: m_address,
                callbackId: tvm.functionId(onSuccess),
                onErrorId:  tvm.functionId(onErrorRepeatDeploy),
                time: 0,
                expire: 0,
                sign: true,
                pubkey: none,
                stateInit: image,
                call: {AshopList, m_masterPubKey}
            });
            tvm.sendrawmsg(deployMsg, 1);
    }


    function onErrorRepeatDeploy(uint32 sdkError, uint32 exitCode) public view {
        // TODO: check errors if needed.
        sdkError;
        exitCode;
        deploy();
    }

    function setStat(PurchaseSummary stat) public {
        m_stat = stat;
        _menu();
    }


    function _getStat(uint32 answerId) private view {
        optional(uint256) none;
        IntShopList(m_address).getStat{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: answerId,
            onErrorId: 0
        }();
    }

    function onCodeUpgrade() internal override {
        tvm.resetStorage();
    }

    function showList(uint32 index) public view {
        index = index;
        optional(uint256) none;
        IntShopList(m_address).getPurchases{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showList_),
            onErrorId: 0
        }();
    }

    function showList_(Purchase[] list) public {
        uint32 i;
        if (list.length > 0 ) {
            Terminal.print(0, "Your purchases list:");
            for (i = 0; i < list.length; i++) {
                Purchase buy = list[i];
                string completed;
                if (buy.isBought) {
                    completed = '✓';
                    Terminal.print(0, format("{} {}  \"{}\". Required quantity: {}. Total costs: {}. Created at {}", buy.id, completed, buy.name, buy.count, buy.sum, buy.timstamp));
                } else {
                    completed = ' ';
                    Terminal.print(0, format("{} {}  \"{}\". Required quantity: {}. Created at {}", buy.id, completed, buy.name, buy.count, buy.timstamp));
                }
                
            }
        } else {
            Terminal.print(0, "Your purchases list is empty");
        }
        _menu();
    }

    function deleteRecord(uint32 index) public {
        index = index;
        if (m_stat.paid + m_stat.unpaid > 0) {
            Terminal.input(tvm.functionId(deleteRecord_), "Enter task number:", false);
        } else {
            Terminal.print(0, "Sorry, you have no items to delete");
            _menu();
        }
    }

    function deleteRecord_(string value) public view {
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        IntShopList(m_address).deletePurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(uint32(num));
    }

}
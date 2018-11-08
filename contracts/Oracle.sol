pragma solidity ^0.4.24;

contract Oracle {

    address public owner;

    uint private ethToUsd;
    uint private btcToUsd;

    event CallbackGetEthToUsdPrice();
    event CallbackGetBtcToUsdPrice();

    constructor() public {
        owner = msg.sender;
    }

    function updatePrices() public {
        emit CallbackGetEthToUsdPrice();
        emit CallbackGetBtcToUsdPrice();
    }

    function getEthToUsdPrice() external view returns (uint) {
        return ethToUsd;
    }
    
    function getBtcToUsdPrice() external view returns (uint) {
        return btcToUsd;
    }

    // вызываются оракулом
    function setEthToUsdPrice(uint _ethToUsd) public onlyOracle {
        ethToUsd = _ethToUsd;
    }

    function setBtcToUsdPrice(uint _btcToUsd) public onlyOracle{
        btcToUsd = _btcToUsd;
    }
    
    modifier onlyOracle() {
        require(msg.sender == owner, "Only Oracle Owner can call this function");
        _;
    }
}

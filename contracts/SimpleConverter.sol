pragma solidity ^0.4.24;

import "./OracleInterface.sol";
import "./Safemath.sol";

contract SimpleConverter {
    
    using SafeMath for uint;
    
    address public deployedOracle;
    
    function setOracleAddress (address _addr) external {
        deployedOracle = _addr;
    }
   
    function convertUsdToEth(uint _usdAmount) external view usingOracle returns (uint) {
        OracleInterface oracle = OracleInterface(deployedOracle);
        uint ethToUsdPrice = oracle.getEthToUsdPrice();
        return _usdAmount.mul(10000000).div(ethToUsdPrice); //divide the result by 100000, for 5num floating precision
    }
    
    function convertUsdToBtc(uint _usdAmount) external view usingOracle returns (uint) {
        OracleInterface oracle = OracleInterface(deployedOracle);
        uint btcToUsdPrice = oracle.getBtcToUsdPrice();
        return _usdAmount.mul(10000000).div(btcToUsdPrice); //divide the result by 100000, for 5num floating precision
    }
    
    function convertEthToBtc(uint _ethAmount) external view usingOracle returns (uint) {
        OracleInterface oracle = OracleInterface(deployedOracle);
        uint ethToUsdPrice = oracle.getEthToUsdPrice();
        uint btcToUsdPrice = oracle.getBtcToUsdPrice();
        uint ethToBtcPrice = ethToUsdPrice.div(btcToUsdPrice);
        return _ethAmount.mul(10000000).mul(ethToBtcPrice); //divide the result by 100000, for 5num floating precision
    }

    function convertBtcToEth(uint _btcAmount) external view usingOracle returns (uint) {
        OracleInterface oracle = OracleInterface(deployedOracle);
        uint ethToUsdPrice = oracle.getEthToUsdPrice();
        uint btcToUsdPrice = oracle.getBtcToUsdPrice();
        uint btcToEthPrice = btcToUsdPrice.div(ethToUsdPrice);
        return _btcAmount.mul(10000000).mul(btcToEthPrice); //divide the result by 100000, for 5num floating precision
    }
    
    function getEthToUsdPrice() external view usingOracle returns(uint) {
        OracleInterface oracle = OracleInterface(deployedOracle);
        return oracle.getEthToUsdPrice();
    }
    
    function getBtcToUsdPrice() external view returns(uint) {
        OracleInterface oracle = OracleInterface(deployedOracle);
        return oracle.getBtcToUsdPrice();
    }
    
    modifier usingOracle {
        require(deployedOracle != address(0), "Set the deployed Oracle Contract address");
        _;
    }
}


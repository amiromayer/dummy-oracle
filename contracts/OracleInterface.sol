pragma solidity ^0.4.24;

interface OracleInterface {
  function getEthToUsdPrice() external view returns (uint);
  function getBtcToUsdPrice() external view returns (uint);
}
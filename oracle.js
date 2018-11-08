var fetch = require("fetch");
var OracleContract = require("./build/contracts/Oracle.json");
var contract = require("truffle-contract");

var Web3 = require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

var oracleContract = contract(OracleContract);
oracleContract.setProvider(web3.currentProvider);

// Web3@1.0.0 support for localhost testrpc
// https://github.com/trufflesuite/truffle-contract/issues/56#issuecomment-331084530
if (typeof oracleContract.currentProvider.sendAsync !== "function") {
  oracleContract.currentProvider.sendAsync = function() {
    return oracleContract.currentProvider.send.apply(
      oracleContract.currentProvider,
      arguments
    );
  };
}

// Get accounts from web3
web3.eth.getAccounts((err, accounts) => {
  oracleContract
    .deployed()
    .then(oracleInstance => {
      // Watch event and respond with callback function
      // Get ETH to USD price
      oracleInstance.CallbackGetEthToUsdPrice().watch((err, event) => {
        // Fetch data and update it in the contract
        fetch.fetchUrl(
          "https://api.coinmarketcap.com/v2/ticker/1027/",
          (err, m, b) => {
            const json = JSON.parse(b.toString());
            const ethToUsdPrice = json.data.quotes.USD.price.toFixed(2) * 100;
            console.log("ETH-USD: " + json.data.quotes.USD.price.toFixed(2));

            // Send data back to contract
            oracleInstance.setEthToUsdPrice(ethToUsdPrice, {
              from: accounts[0]
            });
          }
        );
      });

      // Get BTC to USD price
      oracleInstance.CallbackGetBtcToUsdPrice().watch((err, event) => {
        // Fetch data and update it in the contract
        fetch.fetchUrl(
          "https://api.coinmarketcap.com/v2/ticker/1/",
          (err, m, b) => {
            const json = JSON.parse(b.toString());
            const btcToUsdPrice = json.data.quotes.USD.price.toFixed(2) * 100;
            console.log("BTC-USD: " + json.data.quotes.USD.price.toFixed(2));

            // Send data back to contract
            oracleInstance.setBtcToUsdPrice(btcToUsdPrice, {
              from: accounts[0]
            });
          }
        );
      });
    })
    .catch(err => {
      console.log(err);
    });
});

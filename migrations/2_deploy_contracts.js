// requiring the contract
var Management = artifacts.require("./Management.sol");

// exporting as module 
 module.exports = function(deployer) {
  deployer.deploy(Management);
 };


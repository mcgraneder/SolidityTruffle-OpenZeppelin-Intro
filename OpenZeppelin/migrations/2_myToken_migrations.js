const MyToken = artifacts.require("MyToken");

module.exports = function (deployer) {
  //var cap = 100000000;
  deployer.deploy(MyToken, 100000);
};

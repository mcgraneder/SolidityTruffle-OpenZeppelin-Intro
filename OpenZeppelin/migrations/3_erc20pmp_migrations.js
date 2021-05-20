const ERC20PMP = artifacts.require("ERC20PMP");

module.exports = function (deployer) {
  deployer.deploy(ERC20PMP, "MyToken2", "MTKN2");
};

const helloWorld = artifacts.require("helloWorld");

module.exports = function (deployer, network, accounts) {
  deployer.deploy(helloWorld).then(function(instance) {
    instance.setMessage("My name is EVAN", {value: 1000, from: accounts[0]}).then(function(){
      console.log("success");
    }).catch(function(err) {
      console.log("error: " + err);
    });
  });
};

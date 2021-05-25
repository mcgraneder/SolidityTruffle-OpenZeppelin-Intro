const helloWorld = artifacts.require("helloWorld");

contract("helloWord", async function() {
    it("Message should be correct", async() => {
        let instance = await helloWorld.deployed();
        let message = await instance.getMessage();
        assert(message === "My name is EVAN");
     

    });
   

});
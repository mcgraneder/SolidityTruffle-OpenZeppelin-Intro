const People = artifacts.require("People");
const { reverts } = require('truffle-assertions');
const truffleAssert = require('truffle-assertions');

//person should be below 125 years or age
//cannot create a person without payment
//should set senior status correctly
//should set age correctly
//
contract("People", accounts => {

    //beforeEach()
    //adfter()
    //afterEach()
    before(async () => {
        instance = await People.deployed();
    });

    it("require that a persons age must be less that 125 years old", async() => {

        //write our teset
        await truffleAssert.passes(instance.createPerson("Evan", 50, 190, {value: web3.utils.toWei("1", "ether")}));
        await truffleAssert.reverts(instance.createPerson("Evan", 200, 190, {value: web3.utils.toWei("1", "ether")}));
        await truffleAssert.reverts(instance.createPerson("Evan", 20, 190, {value: web3.utils.toWei("0", "ether")}));
        await truffleAssert.reverts(instance.createPerson("Evan", 200, 190, {value: web3.utils.toWei("0", "ether")}));

    });

    it("Cannot create a perosn with out paying at least 1 ether", async() => {
        
        //write our teset
        await truffleAssert.passes(instance.createPerson("Evan", 50, 190, {value: web3.utils.toWei("1", "ether")}));
        await truffleAssert.reverts(instance.createPerson("Evan", 50, 190, {value: web3.utils.toWei("0", "ether")}));

    });

    it("sensior status should be given to people over the age of 65", async() => {
        
        //write our teset
        await instance.createPerson("Evan", 70, 190, {value: web3.utils.toWei("1", "ether")});
        let person = await instance.getPerson();
        await assert(person.age > 65 && person.senior);
        //reverts(person.age > 65);

    });

    it("people under the age of 65 should nto have senior status", async() => {
        
        //write our teset
        await instance.createPerson("Evan", 55, 190, {value: web3.utils.toWei("1", "ether")});
        let person = await instance.getPerson();
        await assert(person.age < 65 && !person.senior);
        //reverts(person.age > 65);

    });

    it("only the contract owner cam delete a person instance", async() => {

        await instance.createPerson("Evan", 70, 190, {value: web3.utils.toWei("1", "ether")});
         
        await truffleAssert.reverts(instance.deletePerson(accounts[1], {from: accounts[1]}));   
        await truffleAssert.passes(instance.deletePerson(accounts[1], {from: accounts[0]}));
        
    });
})
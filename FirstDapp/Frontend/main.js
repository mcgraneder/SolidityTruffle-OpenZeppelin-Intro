var web3 = new Web3(Web3.givenProvider);
var contractInstance;
contract_address = "0xBb1F674Fa2C34d67A0407949d824BDA424D6F9E6";

$(document).ready(function() {
    //enable web to connect to metamask since async function
    //cann .then() and then the function we want to call
    window.ethereum.enable().then(function(accounts) {

        //define contract instance
        contractInstance = new web3.eth.Contract(abi, contract_address, {from: accounts[0]});
        console.log(contractInstance);

    });
    //we want to make a clickable button that executes our create person instance
    //we can use j query but must include our function call in the window
    //this represents the ID of our button tag in index.html
    $("#add_data_button").click(inputData)
    //insyanciate the get data button
    $("#get_data_button").click(getData);

});

//input data function to be called in jQuery button click
function inputData(){
    //to input data we need the values of the create person forum
    var name = $("#name_input").val(); //.val() gets the value 
    var age = $("#age_input").val();
    var height = $("#height_input").val();
    
    var config = {
        value: web3.utils.toWei("1", "ether")
    }
    //now that we have gotten our inut data via jQuery we can call out
    //contratc function instance
    ///we use .on() which is an event listener which we can use to get qlerts f
    //for events
    contractInstance.methods.createPerson(name, age, height).send(config)
    //get transaction has on creation
    .on("transactionHash", function(hash) {
        console.log(hash);

    })
    //get confirmation message on confirmation
    .on("confirmation", function(confirmationNr) {
        console.log(confirmationNr);
        

    })
    //get receipt when ransaction is first mined
    .on("receipt", function(receipt) {
        console.log(receipt);
        alert("Transaction successful");


    });
}

//next we want to create a function which gets the data we inputted above
function getData() {
    //now that we are getting data with a getter function we domt need 
    //to specify as much info as we did above. to query data from the blockchain we
    //can
    contractInstance.methods.getPerson().call().then(function(res) {
        //now we call jQuery to convert our data into text and siaplay it
        $("#name_output").text(res.name);
        $("#age_output").text(res.age);
        $("#height_output").text(res.height);
    })
}

import Web3 from "web3";
import OrganiseArtifact from "../../build/contracts/Organisation.json";

const App = {
  web3: null,
  account: null,
  meta: null,

  start: async function() {
    const { web3 } = this;

    try {
      
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = OrganiseArtifact.networks[networkId];
      this.meta = new web3.eth.Contract(
        OrganiseArtifact.abi,
        deployedNetwork.address,
      );

    
      const accounts = await web3.eth.getAccounts();
      this.account = accounts[0];

    } catch (error) {
      console.error("Could not connect to contract or chain.");
    }
  },

 

  addAddress: async function() {
    const receiver = document.getElementById("receiver").value;
    this.setStatus("Initiating transaction... (please wait)");

    const { addAddresses } = this.meta.methods;
    await addAddresses(receiver).send({ from: this.account });

    this.setStatus("Transaction complete!");
  },

  setStatus: function(message) {
    const status = document.getElementById("status");
    status.innerHTML = message;
  },
};

window.App = App;

window.addEventListener("load", function() {
  if (window.ethereum) {
    App.web3 = new Web3(window.ethereum);
    window.ethereum.enable();
  } else {
    console.warn(
      "No web3 detected. Falling back to http://127.0.0.1:8545."
    );
    App.web3 = new Web3(
      new Web3.providers.HttpProvider("http://127.0.0.1:8545")
    );
  }

  App.start();
});

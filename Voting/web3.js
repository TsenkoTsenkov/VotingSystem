var Web3 = require('web3');
var web3 = new Web3('http://localhost:7545');

if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    web3 = new Web3(new providers.HttpProvider("http://localhost:8545"));
}

const address = '0x7603eBA75c12e48863a5d52d626a4e14c8fDbAb0';
web3.eth.getBalance(address, (err, wei) => {
    balance = web3.utils.fromWei(wei, 'ether')
})

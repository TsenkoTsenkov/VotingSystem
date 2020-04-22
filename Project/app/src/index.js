document.getElementById("connectToMetamask").addEventListener("click", () => {
  getAccount();
});

document.getElementById("checkAddressButton").addEventListener("click", () => {
  showSelectedAddress.innerHTML = ethereum.selectedAddress;
});

async function getAccount() {
  const accounts = await ethereum.enable();
  const account = accounts[0];
  showAccount.innerHTML = account;
}

ethereum.on('accountsChanged', function (accounts) {
  alert('The account has changed');
  showAccount.innerHTML = account;
})

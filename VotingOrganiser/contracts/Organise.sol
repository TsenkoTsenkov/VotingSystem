pragma solidity >= 0.5.0 < 0.7.0;

contract Organise {
    address[10] addresses;
    address organiser;

    constructor() public {
        organiser = msg.sender;
        addresses[0] = organiser;
    }

    modifier onlyOrganiser {
        require(
            msg.sender == organiser,
             "Only the organiser can call ths function."
        );
        _;
    }

    function addAddresses(address Address) public onlyOrganiser returns(address) {
        for(uint i = 0; i<addresses.length; i++) {
            if(addresses[i] == Address) {
                revert("The Address has already been added");
            }
        }
        for(uint i = 1; i<addresses.length; i++) {
            if(addresses[i] == 0x0000000000000000000000000000000000000000) {
                addresses[i] = Address;
                return Address;
            }
        }

    }
}
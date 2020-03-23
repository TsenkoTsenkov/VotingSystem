pragma solidity >= 0.5.0 < 0.7.0;

import "./YesNoVoting.sol";
import "./YesNoCategory.sol";
import "./CategoryFactoryAdd.sol";
import "./CategoryFactoryRemove.sol";

contract Organisation {

    address[] public addresses;
    address[] public votingsAddresses;
    address[] public categoryAddresses;

    constructor(address[] memory _addresses) public {
        require(_addresses.length >= 2, "Should add at least 2 more people to the group");
        for(uint i = 0; i < _addresses.length; i++){
            if(_addresses[i] == msg.sender){
                revert("Don't add your address. You are already part of the group");
            }
        }
        addresses = _addresses;
        addresses.push(msg.sender);
    }

    modifier inOrganisation() {
        bool isIn = false;
        for(uint i = 0; i<addresses.length; i++) {
            if(addresses[i] == msg.sender) {
                isIn = true;
                continue;
            }
        }
        if(isIn) {
            _;
        } else {
            revert('You are not part of the organisation');
        }

    }

    function getAddresses() external view returns(address[] memory) {
        return addresses;
    }

    function addVotingAddress(address _address) public returns(bool) {
        votingsAddresses.push(_address);
        return true;
    }

    function addCategoryAddress(address _address) public returns(bool) {
        categoryAddresses.push(_address);
        return true;
    }

    function removeCategoryAddress(address _address) public returns(bool) {
        for(uint i = 0; i<categoryAddresses.length; i++) {
            if(categoryAddresses[i] == _address) {
                categoryAddresses[i] = categoryAddresses[categoryAddresses.length-1];
                categoryAddresses.pop();
                return true;
            }
        }
        return false;
    }

    function setAddresses(address[] calldata _addresses)
     external inOrganisation() returns(bool) {
        addresses = _addresses;
        return true;
    }

    function addAddress(
        address Address,
        uint startDate,
        uint endDate,
        string memory votingDescription
    )
        public inOrganisation() returns(address)
    {
        for(uint i = 0; i<addresses.length; i++) {
            if(addresses[i] == Address) {
                revert("The Address has already been added");
            }
        }
        YesNoVoting _YesNoVoting = new YesNoVoting(
            startDate,
            endDate,
            0,
            Address,
            this,
            addresses,
            votingDescription
        );
        votingsAddresses.push(address(_YesNoVoting));
        return address(_YesNoVoting);
    }

    function removeAddress(
        address Address,
        uint startDate,
        uint endDate,
        string memory votingDescription
    )
     public inOrganisation() returns(address)
    {
        for(uint i = 0; i<addresses.length; i++) {
            if(addresses[i] == Address) {
                YesNoVoting _YesNoVoting = new YesNoVoting(
                    startDate,
                    endDate,
                    1,
                    Address,
                    this,
                    addresses,
                    votingDescription
                );
                votingsAddresses.push(address(_YesNoVoting));
                return address(_YesNoVoting);
            }
        }
        revert("These is no such address in the organisation");
    }

    function addCategory(
        uint startDate,
        uint endDate,
        string memory votingDescription,
        string memory name,
        address parent,
        uint votingType
    )
     public inOrganisation() returns(address)
     {
         CategoryFactoryAdd catFactory = CategoryFactoryAdd(0xe26C71417E732F49b1c77d5Bf0534A62ea172A07);
         address VotingAddress = catFactory.createCategory(
                startDate,
                endDate,
                votingDescription,
                name,
                parent,
                address(this),
                votingType
          );
          return VotingAddress;
     }

    function removeCategory (uint startDate, uint endDate, address category, string memory votingDescription)
        public returns(address)
    {
        CategoryFactoryRemove catFactory = CategoryFactoryRemove(0x5721C80d64aa0B24304f3B9967CCcCce5ee42761);
        address votingAddress = catFactory.removeCategory(
            startDate,
            endDate,
            category,
            address(this),
            votingDescription
        );

        return votingAddress;
    }

}
pragma solidity >= 0.5.0 < 0.7.0;

import "./Plurality.sol";
import "./Majoritarian.sol";
import "./Organisation.sol";

contract Category {
    string name;
    address public parent;
    address organisation;
    uint votingType;

    constructor(
        string memory _name,
        address _parent,
        address _organisation,
        uint _votingType
    )
        public
    {
        name = _name;
        parent = _parent;
        _organisation = organisation;
        votingType = _votingType;
    }

    modifier validOrganisation() {
        require(msg.sender == organisation, "You are not part of the organisation");
        _;
    }

    function createVoting(
        uint256 _startDate,
        uint256 _endDate,
        address[] calldata _voteAddresses,
        string calldata _votingDescription,
        bytes32[] calldata proposalNames
    )
        external
        validOrganisation()
        returns(address)
    {
        require(votingType == 1 || votingType == 2, "This category can't to that kind of voting");
        if(votingType == 1) {
            Plurality _Plurality = new Plurality(
                _startDate,
                _endDate,
                _voteAddresses,
                _votingDescription,
                proposalNames
            );
            return address(_Plurality);
        } else if(votingType == 2) {
            Majoritarian _Majoritarian = new Majoritarian(
                _startDate,
                _endDate,
                _voteAddresses,
                _votingDescription,
                proposalNames
            );
            return address(_Majoritarian);
        }
    }

    //overloading createVoting()
    //function createVoting()

    function destroy() public validOrganisation() returns(bool){
        selfdestruct(address(0));
    }

}


pragma solidity >= 0.6.0 < 0.7.0;

import "./YesNoVoting.sol";
import "./Category.sol";

contract YesNoCategory is YesNoVoting {

    string name;
    address parent;
    uint votingType;

    constructor(
        uint _startDate,
        uint _endDate,
        uint256 _operationNumber,
        address _Address,
        Organisation _senderAddress,
        address[] memory _voteAddresses,
        string memory _votingDescription,
        string memory _name,
        address _parent,
        uint _votingType
    )
        YesNoVoting(_startDate, _endDate, _operationNumber, _Address, _senderAddress, _voteAddresses, _votingDescription)
        public
    {
        name = _name;
        parent = _parent;
        votingType = _votingType;
        org = _senderAddress;
    }

    function result() public  override returns (address) {
        require(endDate < now, "You can get the results after the voting has ended!");
        bytes32  winningProposalName = "NO";
        if (proposals[0].voteCount > proposals[1].voteCount) {
            winningProposalName = "YES";
        }

        emit VotingResults(winningProposalName, "YesNoCat");

        if (operationNumber == 0) {
            if (winningProposalName == "YES") {
                Category newCategory = new Category(name, parent, address(org), votingType);
                org.addCategoryAddress(address(newCategory));
                return address(newCategory);
            }
        } else if (operationNumber == 1) {
             if (winningProposalName == "YES") {
                while(Address != address(0)) {
                    Category exCategory = Category(Address);
                    Address = exCategory.parent();
                    org.removeCategoryAddress(address(Address));
                    exCategory.destroy();
                }
            }
            return address(0);
        }

    }
}
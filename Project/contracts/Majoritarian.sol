pragma solidity >= 0.6.0 <= 0.7.0;

import "./Plurality.sol";

contract Majoritarian is Plurality {
    constructor(
        uint256 _startDate,
        uint256 _endDate,
        address[] memory _voteAddresses,
        string memory _votingDescription,
        bytes32[] memory _proposalNames
    )
    Plurality(_startDate, _endDate, _voteAddresses, _votingDescription, _proposalNames)
    public
    {}

    function result() public canGetResults() inOrganisation() override returns(address) {
        uint maxCount;
        uint allVotes;
        uint winningIndex = 0;
        for(uint i = 0; i<proposals.length; i++) {
            allVotes += proposals[i].voteCount;
            if(maxCount < proposals[i].voteCount) {
                maxCount = proposals[i].voteCount;
                winningIndex = i;
            }
        }

        if(compareDecimals((maxCount*100), allVotes, 50, 1)) {
            emit VotingResults(proposals[winningIndex].name, "Majoritarian");
        } else {
            emit VotingResults("Doesn't have majority", "Majoritarian");
        }
        return msg.sender;
    }

    function compareDecimals(uint divisible1, uint divider1, uint divisible2, uint divider2) internal pure returns(bool) {
        if(divider1 == divider2) {
            return divisible1 > divisible2;
        } else {
            uint ok = divider1 * divider2;
            return ((ok/divider1) * divisible1) > ((ok/divider2) * divisible2);
        }
    }
}
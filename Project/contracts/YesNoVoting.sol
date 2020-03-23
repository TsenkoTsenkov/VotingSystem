pragma solidity >= 0.6.0 < 0.7.0;

import "./Organisation.sol";
import "./AbstractVoting.sol";

contract YesNoVoting is AbstractVoting{

    uint256 operationNumber;
    address Address;
    Organisation org;

    struct Voter{
        uint weight;
        bool hasVoted;
        address delegateAddress;
        uint vote;
    }

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    mapping(address => Voter) public voters;
    Proposal[2] public proposals;

    constructor(
        uint _startDate,
        uint _endDate,
        uint256 _operationNumber,
        address _Address,
        Organisation _senderAddress,
        address[] memory _voteAddresses,
        string memory _votingDescription
    )
        AbstractVoting(_startDate, _endDate, _voteAddresses, _votingDescription)
        public
    {
        operationNumber = _operationNumber;
        Address = _Address;
        org = _senderAddress;

         for(uint i = 0; i<voteAddresses.length; i++) {
            Voter storage voter = voters[voteAddresses[i]];
            voter.weight = 1;
            voter.hasVoted = false;
            voter.delegateAddress = address(0);
         }

        proposals[0].name = "YES";
        proposals[0].voteCount = 0;
        proposals[1].name = "NO";
        proposals[1].voteCount = 0;
    }

    function vote(uint proposal) public betweenDate(now) inOrganisation() override returns(bool) {
        require(proposal >= 0 && proposal <= 1, "Only 2 choices");
        Voter storage sender = voters[msg.sender];
        require(!sender.hasVoted, "Already voted.");
        sender.hasVoted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;

        return true;
    }

    function delegate(address _to) public betweenDate(now) inOrganisation() override  returns(bool) {
        require(_to != address(0), "This is an empty address");
        address to = _to;
        Voter storage sender = voters[msg.sender];
        require(!sender.hasVoted, "You already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");

        while (voters[to].delegateAddress != address(0)) {
            to = voters[to].delegateAddress;
            require(to != msg.sender, "Found loop in delegation.");
        }

        sender.hasVoted = true;
        sender.delegateAddress = to;
        Voter storage delegateAddress_ = voters[to];
        if (delegateAddress_.hasVoted) {
             proposals[delegateAddress_.vote].voteCount += sender.weight;
        }
        delegateAddress_.weight += sender.weight;
        return true;
    }

    function resetVote() public betweenDate(now) inOrganisation() override returns(bool) {
        Voter storage sender = voters[msg.sender];
        require(sender.hasVoted, "You haven't voted yet");

        if(sender.delegateAddress == address(0)) {
            proposals[sender.vote].voteCount -= sender.weight;
            sender.hasVoted = false;
        }

        return true;
    }

    function result() public inOrganisation() virtual override returns (address) {
        require(endDate < now, "You can get the results after the voting has ended!");
        bytes32  winningProposalName = "NO";
        if (proposals[0].voteCount > proposals[1].voteCount) {
            winningProposalName = "YES";
        }

        if (operationNumber == 0) {
            if (winningProposalName == "YES") {
                voteAddresses.push(Address);
                org.setAddresses(voteAddresses);
            }
        } else if (operationNumber == 1) {
             if (winningProposalName == "YES") {
                for (uint i = 0; i<voteAddresses.length; i++) {
                    if(voteAddresses[i] == Address) {
                        removeAddress(i);
                        org.setAddresses(voteAddresses);
                        continue;
                    }
                }
            }
        }

        emit VotingResults(winningProposalName, "YesNo");
        return Address;
    }

    function removeAddress(uint index) private returns(bool) {
       voteAddresses[index] = voteAddresses[voteAddresses.length - 1];
        delete voteAddresses[voteAddresses.length - 1];
        voteAddresses.pop();
        return true;
    }

}
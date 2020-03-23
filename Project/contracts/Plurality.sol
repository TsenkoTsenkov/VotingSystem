pragma solidity >= 0.6.0 < 0.7.0;

import "./AbstractVoting.sol";

contract Plurality is AbstractVoting {

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
    Proposal[] public proposals;

    constructor(
        uint256 _startDate,
        uint256 _endDate,
        address[] memory _voteAddresses,
        string memory _votingDescription,
        bytes32[] memory proposalNames
    )
     AbstractVoting(_startDate, _endDate, _voteAddresses, _votingDescription)  public
    {

        for(uint i = 0; i<voteAddresses.length; i++) {
            voters[voteAddresses[i]].weight = 1;
        }

        for(uint i = 0; i<proposalNames.length; i++) {
            proposals.push(
                Proposal({
                    name: proposalNames[i],
                    voteCount: 0
                })
            );
        }
    }

    function delegate(address _to) public  betweenDate(now) inOrganisation() override  returns(bool) {
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
        } else {
            delegateAddress_.weight += sender.weight;
        }
        return true;
    }

    function vote(uint proposal) public betweenDate(now) inOrganisation() override returns(bool) {
        require(proposal >= 0 && proposal <= proposals.length, 'Invalid proposal');
        Voter storage sender = voters[msg.sender];
        require(!sender.hasVoted, "Already voted.");
        sender.hasVoted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;
        return true;
    }

    function result() public canGetResults() inOrganisation() virtual override returns(address) {
        uint maxCount;
        uint winningIndex = 0;
        for(uint i = 0; i<proposals.length; i++) {
            if(maxCount <= proposals[i].voteCount) {
                maxCount = proposals[i].voteCount;
                winningIndex = i;
            }
        }

        for(uint i = 0; i<proposals.length; i++) {
            if(proposals[winningIndex].voteCount == proposals[i].voteCount && winningIndex != i) {
                emit VotingResults("There isn't pluralirty", "Plurality");
                return msg.sender;
            }
        }
        emit VotingResults(proposals[winningIndex].name, "Plurality");
        return msg.sender;
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

}
pragma solidity >=0.4.22 <0.6.0;

contract YesNoVoting {
    
    struct Voter {
        uint8 vote;
        bool canVote;
        bool voted;
    }
    
    struct Proposal{
        uint voteCount;
    }
    
    address chairperson;
    mapping(address => Voter) voters;
    
    Proposal[2] proposals;
    
    constructor() public {
        chairperson = msg.sender;
    }
    
    
    function giveRightToVote(address toVoter) public {
        if (msg.sender != chairperson || voters[toVoter].voted) return;
        voters[toVoter].canVote = true;
    }
    
    function vote(uint8 toProposal) public {
        Voter storage sender = voters[msg.sender];
        if (sender.voted && !sender.canVote) return;
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount++;
    }
    
    function winningProposal() public view returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
    }
}
pragma solidity >= 0.6.0 < 0.7.0;

abstract contract AbstractVoting {
    
    uint256 startDate;
    uint256 endDate;
    address[] public voteAddresses;
    string votingDescription;

    event VotingResults(bytes32 winningName, bytes32 Type);

    constructor(uint _startDate, uint _endDate, address[] memory _voteAddresses, string memory _votingDescription) public{
        startDate = _startDate;
        endDate = _endDate;
        voteAddresses = _voteAddresses;
        votingDescription = _votingDescription;
    }

    modifier betweenDate(uint Date) {
        if (!(startDate <= Date && Date <= endDate)) {
            revert('You can not do that now');
        }
        _;
    }

     modifier canGetResults() {
         require(endDate < now, "You can get the results after the voting has ended!");
         _;
    }

    modifier inOrganisation() {
        for(uint i = 0; i<voteAddresses.length; i++) {
            if(voteAddresses[i] == msg.sender) {
                _;
            }    
        }
        revert('You are not part of the organisation');
    }

    function vote(uint proposal) public virtual returns(bool);

    function delegate(address _to) public virtual  returns(bool);

    function result() public virtual returns(address);

    function resetVote() public virtual returns(bool);
    
}
pragma solidity >= 0.5.0 < 7.0.0;

import "./YesNoCategory.sol";
import "./Organisation.sol";

contract CategoryFactoryAdd {

    event votingAddress(address VotingAddress);

    function createCategory(
        uint startDate,
        uint endDate,
        string memory votingDescription,
        string memory name,
        address parent,
        address organisationAddress,
        uint votingType
    )
    public returns(address)
    {
        Organisation organisation = Organisation(organisationAddress);

        YesNoCategory _YesNoCategory = new YesNoCategory(
            startDate,
            endDate,
            0,
            address(0),
            organisation,
            organisation.getAddresses(),
            votingDescription,
            name,
            parent,
            votingType
        );
        organisation.addVotingAddress(address(_YesNoCategory));
        emit votingAddress(address(_YesNoCategory));
        return address(_YesNoCategory);
    }

}

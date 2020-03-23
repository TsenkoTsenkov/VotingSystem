pragma solidity >= 0.5.0 < 7.0.0;

import "./YesNoCategory.sol";
import "./Organisation.sol";

contract CategoryFactoryRemove {

    event votingAddress(address VotingAddress);

    function removeCategory(
        uint startDate,
        uint endDate,
        address category,
        address organisationAddress,
        string memory votingDescription
    )
        public  returns(address)
    {
        Organisation organisation = Organisation(organisationAddress);

        YesNoCategory _YesNoCategory = new YesNoCategory(
            startDate,
            endDate,
            1,
            category,
            organisation,
            organisation.getAddresses(),
            votingDescription,
            "none",
            address(0),
            0
        );
        emit votingAddress(address(_YesNoCategory));
        return address(_YesNoCategory);
    }

}


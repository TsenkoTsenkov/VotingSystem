import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

import "../contracts/Organise.sol";

contract TestOrganaise {
    function testOrganiserPrivilege() {
        Organise organise = Organise(DeployedAddresses.Organise());

    }
}

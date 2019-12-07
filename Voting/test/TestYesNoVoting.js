const YesNoVoting = artifacts.require("YesNoVoting");

it("should vote correctly", async() => {
    let instance = await YesNoVoting.deployed();

    instance.vote(1);
    instance.vote(1);

    let voteCount = await instance.getVoteCount(1);
    assert.equal(voteCount, 1);
})

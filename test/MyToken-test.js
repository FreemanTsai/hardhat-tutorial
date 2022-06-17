const { expect } = require("chai");
const { ethers } = require("hardhat");
describe("MyToken.sol", () => {
    let contractFactory;
    let contract;
    let owner;
    let initialSupply;
    beforeEach(async () => {
        [owner] = await ethers.getSigners();
        contractFactory = await ethers.getContractFactory("MyToken");
        contract = await contractFactory.deploy();
        initialSupply = ethers.utils.parseEther("10000000");
    });
    it("Should have correct supply", async () => {
        expect(await contract.totalSupply()).to.equal(initialSupply);
    });
    it("Owner should have all the supply", async () => {
        const ownerBalance = await contract.balanceOf(owner.address);
        expect(await contract.totalSupply()).to.equal(ownerBalance);
    });
});
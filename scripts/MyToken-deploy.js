async function main() {
    const [deployer] = await ethers.getSigners();
    const contractName = "MyToken";
    const contractFactory = await ethers.getContractFactory(contractName);
    const contract = await contractFactory.deploy();
    console.log("Contract address:", contract.address);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
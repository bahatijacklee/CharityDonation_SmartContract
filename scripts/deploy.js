const hre = require("hardhat");

async function main() {
  const CharityDonationPlatform = await hre.ethers.getContractFactory("CharityDonationPlatform");
  const charityPlatform = await CharityDonationPlatform.deploy();

  await charityPlatform.deployed();
  console.log(`CharityDonationPlatform deployed to: ${charityPlatform.address}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

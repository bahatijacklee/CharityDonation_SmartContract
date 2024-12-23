const hre = require("hardhat");

async function main() {
  const charityPlatformAddress = "<Deployed Contract Address>";
  const CharityDonationPlatform = await hre.ethers.getContractFactory("CharityDonationPlatform");
  const charityPlatform = await CharityDonationPlatform.attach(charityPlatformAddress);

  // Example: Create a campaign
  const tx = await charityPlatform.createCampaign(
    "Education for All",
    "Funding education for underprivileged children",
    hre.ethers.utils.parseEther("2") // Target: 2 ETH
  );
  await tx.wait();
  console.log("Campaign created!");

  // Example: View campaign
  const campaign = await charityPlatform.campaigns(1);
  console.log("Campaign Details:", campaign);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

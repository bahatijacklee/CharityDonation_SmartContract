const { expect } = require("chai");

describe("CharityDonationPlatform", function () {
  it("Should create and manage campaigns", async function () {
    const [owner, donor] = await ethers.getSigners();
    const CharityDonationPlatform = await ethers.getContractFactory("CharityDonationPlatform");
    const charityPlatform = await CharityDonationPlatform.deploy();
    await charityPlatform.deployed();

    // Create a campaign
    const createTx = await charityPlatform.createCampaign(
      "Clean Water Initiative",
      "Provide clean water",
      ethers.utils.parseEther("1")
    );
    await createTx.wait();

    // Validate campaign creation
    const campaign = await charityPlatform.campaigns(1);
    expect(campaign.title).to.equal("Clean Water Initiative");
  });
});

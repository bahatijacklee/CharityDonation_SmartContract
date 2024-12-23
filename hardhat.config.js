require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      url: process.env.ALCHEMY_SEPOLIA_URL, // Alchemy API URL
      accounts: [process.env.SEPOLIA_PRIVATE_KEY], // Private key for wallet
    },
  },
};

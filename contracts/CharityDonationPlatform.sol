// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CharityDonationPlatform is Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    struct Campaign {
        uint256 id;
        string title;
        string description;
        uint256 targetAmount;
        uint256 raisedAmount;
        address owner;
        bool isCompleted;
        uint256 createdAt;
        uint256 completedAt;
    }

    struct Donation {
        address donor;
        uint256 amount;
    }

    // Campaigns and donations
    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => Donation[]) public donations;

    uint256 public campaignCount;

    event CampaignCreated(
        uint256 campaignId,
        string title,
        string description,
        uint256 targetAmount,
        address owner,
        uint256 createdAt
    );
    event DonationReceived(uint256 campaignId, address donor, uint256 amount);
    event CampaignCompleted(uint256 campaignId, uint256 completedAt);
    event FundsWithdrawn(uint256 campaignId, uint256 amount);

    modifier onlyCampaignOwner(uint256 _campaignId) {
        require(campaigns[_campaignId].owner == msg.sender, "Only campaign owner can perform this action");
        _;
    }

    modifier notCompleted(uint256 _campaignId) {
        require(!campaigns[_campaignId].isCompleted, "Campaign is already completed");
        _;
    }

    // Constructor
    constructor() Ownable(msg.sender) {}

    // Function to create a new campaign
    function createCampaign(
        string memory _title,
        string memory _description,
        uint256 _targetAmount
    ) public {
        require(_targetAmount > 0, "Target amount must be greater than 0");

        campaignCount++;
        campaigns[campaignCount] = Campaign({
            id: campaignCount,
            title: _title,
            description: _description,
            targetAmount: _targetAmount,
            raisedAmount: 0,
            owner: msg.sender,
            isCompleted: false,
            createdAt: block.timestamp,
            completedAt: 0
        });

        emit CampaignCreated(campaignCount, _title, _description, _targetAmount, msg.sender, block.timestamp);
    }

    // Function to donate to a campaign
    function donateToCampaign(uint256 _campaignId) public payable notCompleted(_campaignId) {
        require(msg.value > 0, "Donation must be greater than 0");

        Campaign storage campaign = campaigns[_campaignId];
        campaign.raisedAmount = campaign.raisedAmount.add(msg.value);
        donations[_campaignId].push(Donation(msg.sender, msg.value));

        emit DonationReceived(_campaignId, msg.sender, msg.value);

        // If the target amount is met, mark the campaign as completed
        if (campaign.raisedAmount >= campaign.targetAmount) {
            campaign.isCompleted = true;
            campaign.completedAt = block.timestamp;
            emit CampaignCompleted(_campaignId, block.timestamp);
        }
    }

    // Function to withdraw funds by the campaign owner
    function withdrawFunds(uint256 _campaignId)
        public
        onlyCampaignOwner(_campaignId)
        nonReentrant
    {
        Campaign storage campaign = campaigns[_campaignId];
        require(campaign.isCompleted, "Campaign must be completed to withdraw funds");

        uint256 amount = campaign.raisedAmount;
        campaign.raisedAmount = 0;
        payable(campaign.owner).transfer(amount);

        emit FundsWithdrawn(_campaignId, amount);
    }

    // Helper function to get the donation count for a campaign
    function getDonationCount(uint256 _campaignId) public view returns (uint256) {
        return donations[_campaignId].length;
    }
}

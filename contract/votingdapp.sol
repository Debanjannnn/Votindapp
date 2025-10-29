// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title VoteChori - A simple decentralized voting system
/// @author 
/// @notice Anyone can vote once per proposal. The owner can create new proposals.

contract VoteChori {
    // Owner of the contract (deployer)
    address public owner;

    // Struct to represent a proposal
    struct Proposal {
        uint id;
        string description;
        uint voteCount;
        bool exists;
    }

    // Mapping from proposal ID to proposal details
    mapping(uint => Proposal) public proposals;

    // Mapping to track if an address has voted on a proposal
    mapping(uint => mapping(address => bool)) public hasVoted;

    // Total number of proposals created
    uint public proposalCount;

    // Events
    event ProposalCreated(uint id, string description);
    event Voted(uint proposalId, address voter);
    
    // Constructor sets the deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict functions to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    /// @notice Create a new proposal (owner only)
    /// @param _description The description of the proposal
    function createProposal(string memory _description) public onlyOwner {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, _description, 0, true);
        emit ProposalCreated(proposalCount, _description);
    }

    /// @notice Vote for a proposal by ID
    /// @param _proposalId The ID of the proposal you want to vote for
    function vote(uint _proposalId) public {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.exists, "Proposal does not exist");
        require(!hasVoted[_proposalId][msg.sender], "Already voted for this proposal");

        proposal.voteCount++;
        hasVoted[_proposalId][msg.sender] = true;
        emit Voted(_proposalId, msg.sender);
    }

    /// @notice Get details of a proposal
    /// @param _proposalId The ID of the proposal
    /// @return id, description, voteCount
    function getProposal(uint _proposalId) public view returns (uint, string memory, uint) {
        Proposal memory proposal = proposals[_proposalId];
        require(proposal.exists, "Proposal not found");
        return (proposal.id, proposal.description, proposal.voteCount);
    }
}


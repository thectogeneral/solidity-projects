// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DAO {
    struct Proposal {
        string description;
        uint voteCount;
        bool executed;
    }

    mapping(address => bool) public members;
    Proposal[] public proposals;


    uint public minimumQuorum;
    uint public voteDuration;
    address public owner;

    mapping(uint => mapping(address => bool)) public votes;

    constructor(uint _minimumQuorum, uint _voteDuration) {
        owner = msg.sender;
        minimumQuorum = _minimumQuorum;
        voteDuration = _voteDuration;
        members[owner] = true; // Owner is the first member of the DAO
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyMembers() {
        require(members[msg.sender], "Only members can call this function");
        _;
    }

    function addMember(address member) public onlyOwner {
        members[member] = true;
    }

    function createProposal(string memory description) public onlyMembers {
        proposals.push(Proposal({
            description: description,
            voteCount: 0,
            executed: false
        }));
    }

    function vote(uint proposalIndex) public onlyMembers {
        require(!votes[proposalIndex][msg.sender], "You have already voted");
        require(proposalIndex < proposals.length, "Invalid proposal index");

        votes[proposalIndex][msg.sender] = true;
        proposals[proposalIndex].voteCount++;
    }

    function executeProposal(uint proposalIndex) public onlyMembers {
        Proposal storage proposal = proposals[proposalIndex];
        require(!proposal.executed, "Proposal has already been executed");
        require(proposal.voteCount >= minimumQuorum, "Not enough votes to execute");

        proposal.executed = true;
        // Here you would add code to execute the proposal, e.g., transfer funds or change some state

    }

    function getProposalCount() public view returns (uint) {
        return proposals.length;
    }

    function getProposal(uint proposalIndex) public view returns (string memory description, uint voteCount, bool executed) {
        Proposal storage proposal = proposals[proposalIndex];
        return (proposal.description, proposal.voteCount, proposal.executed);
    }
}
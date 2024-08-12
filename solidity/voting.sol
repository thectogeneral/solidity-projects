// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool hasVoted;
        uint voteIndex;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;

    uint public candidatesCount;

    constructor() {
        addCandidate("Alice");
        addCandidate("Bob");
    }

    function addCandidate(string memory _name) private {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint _candidateId) public {
        require(!voters[msg.sender].hasVoted, "You have already voted");

        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalidat candidate");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].voteIndex = _candidateId;

        candidates[_candidateId].voteCount++;
    }

    function getCandidate(uint _candidateId) public view returns (string memory, uint) {
        return (candidates[_candidateId].name, candidates[_candidateId].voteCount);
    }

    function getVoteCount(uint _candidateId) public view returns (uint) {
        return candidates[_candidateId].voteCount;
    }
}
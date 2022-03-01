
// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./Proposal.sol";


/*
Create a voting contract using factory and state machine pattern
- create instances of Proposal Concepts
- people can vote on proposal 
- Proposal must go through a number of stages (Think Compound Governance)

*/

contract ProposaFactory {

    address[] public proposals;
    uint public numberPropopsals;

    event ProposalCreated(address indexed creator, uint indexed proposalId);
    
    /// @notice Function to create Voting Proposal
    function createProposal() external {
        numberProposals+=1;
        Proposal _newProposal = new Proposal(msg.sender, numberProposals);
        address _proposal = address(_newProposal);
        proposals.push(_proposal);
        emit ProposalCreated(msg.sender, numberProposals);
    }
    
    /// @notice View all the Proposals created by Factory
    /// @return array of addresses of the Proposal Contracts
    function getProposals() external view returns(address[] memory) {
        return proposals;
    }

}


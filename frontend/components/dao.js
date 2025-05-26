// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;  // 🔹 Version Solidity utilisée

// 📌 Définition du contrat de gouvernance de la DAO
contract HorseTokenDAO {
    struct Proposal {
        string description;      // 📌 Description de la proposition
        uint256 votesFor;        // 🔹 Nombre de votes en faveur
        uint256 votesAgainst;    // 🔹 Nombre de votes contre
        bool executed;           // 📌 Indique si la proposition a été exécutée
    }

    Proposal[] public proposals;  // 🔹 Liste des propositions stockées
    mapping(address => bool) public hasVoted;  // 📌 Suivi des votes pour éviter les doubles votes

    // 🔔 Déclaration des événements pour suivre les actions de la DAO sur la blockchain
    event ProposalCreated(string description);
    event VoteSubmitted(address indexed voter, uint256 proposalId, bool voteFor);
    event ProposalExecuted(uint256 proposalId);

    // 📜 **Création d'une proposition**
    function createProposal(string memory _description) external {
        proposals.push(Proposal({
            description: _description,
            votesFor: 0,
            votesAgainst: 0,
            executed: false
        }));

        emit ProposalCreated(_description);  // 🔔 Événement de proposition créée
    }

    // ✉️ **Vote sur une proposition**
    function vote(uint256 proposalId, bool voteFor) external {
        require(!hasVoted[msg.sender], "Déjà voté.");  // 📌 Vérification que l'utilisateur n'a pas déjà voté
        hasVoted[msg.sender] = true;  // 🔹 Marquer l'utilisateur comme ayant voté

        if (voteFor) {
            proposals[proposalId].votesFor += balanceOf(msg.sender);  // 🎯 Ajout des votes en faveur
        } else {
            proposals[proposalId].votesAgainst += balanceOf(msg.sender);  // 🎯 Ajout des votes contre
        }

        emit VoteSubmitted(msg.sender, proposalId, voteFor);  // 🔔 Enregistrement de l'événement
    }

    // ⚖️ **Exécution d'une proposition si elle est validée**
    function executeProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Déjà exécutée.");  // 📌 Vérification que la proposition n'a pas déjà été exécutée
        require(proposal.votesFor > proposal.votesAgainst, "Majorité non atteinte.");  // 🔹 Vérification du consensus

        proposal.executed = true;  // 🎯 Marquer la proposition comme exécutée
        emit ProposalExecuted(proposalId);  // 🔔 Enregistrement de l'événement
    }
}

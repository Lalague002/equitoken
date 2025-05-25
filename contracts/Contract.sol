// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EquiToken is ERC20, Ownable {
    mapping(address => uint256) public lastClaim;
    mapping(address => uint256) public owedDividends;
    uint256 public totalDividends;

    event DividendsReceived(uint256 amount);
    event DividendsClaimed(address indexed user, uint256 amount);

    constructor(uint256 initialSupply) ERC20("EquiToken", "EQT") {
        _mint(msg.sender, initialSupply);
    }

    // 🔁 Réception automatique d'ETH (dividendes à distribuer)
    receive() external payable {
        require(totalSupply() > 0, "Pas de holders EQT.");
        totalDividends += msg.value;
        emit DividendsReceived(msg.value);
    }

    // 🧮 Calcul de la part d'ETH à distribuer à un détenteur EQT
    function calculateOwed(address account) public view returns (uint256) {
        uint256 balance = balanceOf(account);
        if (balance == 0 || totalDividends == 0) return 0;
        return (totalDividends * balance) / totalSupply() - owedDividends[account];
    }

    // 💰 Fonction pour que l'utilisateur réclame ses dividendes
    function claimDividends() external {
        uint256 owed = calculateOwed(msg.sender);
        require(owed > 0, "Aucun dividende disponible.");

        owedDividends[msg.sender] += owed;
        payable(msg.sender).transfer(owed);

        emit DividendsClaimed(msg.sender, owed);
    }
}

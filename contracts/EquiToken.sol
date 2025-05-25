// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// ✅ Import des modules nécessaires uniquement
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EquiToken is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000 * 1e18;

    // 🔐 Répartition initiale
    address public daoTreasury;
    address public teamVestingWallet;
    address public partnersVestingWallet;
    address public marketingWallet;
    address public saleWallet;

    // 💸 Gestion des dividendes
    mapping(address => uint256) public owedDividends;
    uint256 public totalDividends;

    event DividendsReceived(uint256 amount);
    event DividendsClaimed(address indexed user, uint256 amount);

    constructor(
        address _daoTreasury,
        address _teamVestingWallet,
        address _partnersVestingWallet,
        address _marketingWallet,
        address _saleWallet
    ) ERC20("EquiToken", "EQT") {
        require(_daoTreasury != address(0), "Invalid DAO address");
        require(_teamVestingWallet != address(0), "Invalid team address");
        require(_partnersVestingWallet != address(0), "Invalid partners address");
        require(_marketingWallet != address(0), "Invalid marketing address");
        require(_saleWallet != address(0), "Invalid sale address");

        daoTreasury = _daoTreasury;
        teamVestingWallet = _teamVestingWallet;
        partnersVestingWallet = _partnersVestingWallet;
        marketingWallet = _marketingWallet;
        saleWallet = _saleWallet;

        // 🎯 Répartition des 1 000 000 EQT
        _mint(_saleWallet, 500_000 * 1e18);            // 50%
        _mint(_daoTreasury, 200_000 * 1e18);           // 20%
        _mint(_teamVestingWallet, 150_000 * 1e18);     // 15%
        _mint(_partnersVestingWallet, 100_000 * 1e18); // 10%
        _mint(_marketingWallet, 50_000 * 1e18);        // 5%
    }

    // 🔁 Le contrat peut recevoir de l'ETH (gains à redistribuer)
    receive() external payable {
        require(totalSupply() > 0, "No EQT holders.");
        totalDividends += msg.value;
        emit DividendsReceived(msg.value);
    }

    // 🧮 Calcul du montant réclamable par un détenteur EQT
    function calculateOwed(address account) public view returns (uint256) {
        uint256 balance = balanceOf(account);
        if (balance == 0 || totalDividends == 0) return 0;
        return (totalDividends * balance) / totalSupply() - owedDividends[account];
    }

    // 💰 Fonction pour réclamer les dividendes
    function claimDividends() external {
        uint256 owed = calculateOwed(msg.sender);
        require(owed > 0, "Aucun dividende disponible.");

        owedDividends[msg.sender] += owed;
        payable(msg.sender).transfer(owed);

        emit DividendsClaimed(msg.sender, owed);
    }

    // 🔥 Fonction burn standard
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}



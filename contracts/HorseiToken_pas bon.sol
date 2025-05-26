// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;  // 🔹 Version de Solidity utilisée

// 📌 Importation des bibliothèques OpenZeppelin pour hériter des fonctionnalités ERC-20 et Ownable
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// 🏇 Définition du contrat principal HorseToken
contract HorseToken is ERC20, Ownable {
    // 🔹 Définition du nombre maximal de tokens pouvant être créés
    uint256 public constant MAX_SUPPLY = 1_000_000 * 1e18;

    // 🎯 Définition du prix du token en ETH (0,10 € par HRTK)
    uint256 public tokenPrice = 0.000055 ether;

    // 🔐 Adresses pour la répartition initiale des tokens (DAO, équipe, partenaires...)
    address public daoTreasury;
    address public teamVestingWallet;
    address public partnersVestingWallet;
    address public marketingWallet;
    address public saleWallet;

    // 💸 Gestion des dividendes (répartition des gains des courses hippiques)
    mapping(address => uint256) public owedDividends;  // 📌 Stocke les dividendes dus à chaque détenteur
    uint256 public totalDividends;  // 🔹 Montant total des dividendes disponibles

    // 🔔 Déclaration des événements pour suivre les actions importantes sur la blockchain
    event TokensPurchased(address indexed buyer, uint256 amount);
    event DividendsReceived(uint256 amount);
    event DividendsClaimed(address indexed user, uint256 amount);

    // 🛠️ **CONSTRUCTEUR** - Exécution unique lors du déploiement du contrat
    constructor(
        address _daoTreasury,
        address _teamVestingWallet,
        address _partnersVestingWallet,
        address _marketingWallet,
        address _saleWallet
    ) ERC20("HorseToken", "HRTK") {
        // ✅ Vérification des adresses fournies pour éviter les erreurs
        require(_daoTreasury != address(0), "Invalid DAO address");
        require(_teamVestingWallet != address(0), "Invalid team address");
        require(_partnersVestingWallet != address(0), "Invalid partners address");
        require(_marketingWallet != address(0), "Invalid marketing address");
        require(_saleWallet != address(0), "Invalid sale address");

        // 🔹 Attribution des adresses
        daoTreasury = _daoTreasury;
        teamVestingWallet = _teamVestingWallet;
        partnersVestingWallet = _partnersVestingWallet;
        marketingWallet = _marketingWallet;
        saleWallet = _saleWallet;

        // 🎯 Répartition initiale des 1 000 000 HRTK
        _mint(_saleWallet, 500_000 * 1e18);            // 📌 Vente publique : 50%
        _mint(_daoTreasury, 200_000 * 1e18);           // 📌 Réserve stratégique SARL : 20%
        _mint(_teamVestingWallet, 150_000 * 1e18);     // 📌 Équipe fondatrice : 15%
        _mint(_partnersVestingWallet, 100_000 * 1e18); // 📌 Partenaires équestres : 10%
        _mint(_marketingWallet, 50_000 * 1e18);        // 📌 Marketing & Récompenses : 5%
    }

    // 💰 **Fonction permettant d’acheter des tokens en ETH**
    function buyTokens() external payable {
        require(msg.value > 0, "Envoyez des ETH pour acheter des tokens.");  // 📌 Vérification que l’utilisateur envoie bien de l’ETH

        uint256 tokenAmount = (msg.value * 1e18) / tokenPrice;  // 🔹 Conversion ETH → HRTK
        require(totalSupply() + tokenAmount <= MAX_SUPPLY, "Dépassement du total supply.");  // 📌 Vérification que l’on ne dépasse pas l’offre maximale

        _mint(msg.sender, tokenAmount);  // 🎯 Création de nouveaux tokens pour l’utilisateur
        emit TokensPurchased(msg.sender, tokenAmount);  // 🔔 Enregistrement de l’événement
    }

    // 🧮 **Fonction de calcul des dividendes dus à un détenteur de HRTK**
    function calculateOwed(address account) public view returns (uint256) {
        uint256 balance = balanceOf(account);  // 📌 Obtention du solde de HRTK de l’utilisateur
        uint256 totalSupplyCache = totalSupply();  // 🔹 Stockage temporaire pour éviter des calculs répétés
        if (balance == 0 || totalDividends == 0) return 0;  // 📌 Aucun dividende si l’utilisateur ne possède pas de HRTK

        return (totalDividends * balance) / totalSupplyCache - owedDividends[account];  // 🎯 Calcul de la part des gains
    }

    // 💰 **Fonction permettant aux détenteurs de réclamer leurs dividendes**
    function claimDividends() external {
        uint256 owed = calculateOwed(msg.sender);  // 📌 Calcul du montant dû
        require(owed > 0, "Aucun dividende disponible.");  // 🔹 Vérification que l’utilisateur a bien des dividendes à réclamer

        owedDividends[msg.sender] = owed;  // 📌 Mise à jour des dividendes versés
        payable(msg.sender).transfer(owed);  // 🎯 Envoi des ETH à l’utilisateur

        emit DividendsClaimed(msg.sender, owed);  // 🔔 Enregistrement de l’événement
    }

    // 🔥 **Fonction permettant de détruire des tokens (burn)**
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);  // 📌 Suppression définitive des tokens de l’utilisateur
    }

    // 🔗 **Sécurisation des dépôts de gains des courses hippiques**
    receive() external payable {
        require(msg.value > 0, "Must send ETH.");  // 📌 Vérification qu’une valeur positive est envoyée
        require(totalSupply() > 0, "No HRTK holders.");  // 🔹 Vérification que le contrat est bien actif

        totalDividends += msg.value;  // 🎯 Ajout des ETH aux dividendes totaux
        emit DividendsReceived(msg.value);  // 🔔 Enregistrement de l’événement
    }
}


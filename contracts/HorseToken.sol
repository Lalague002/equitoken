// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HorseToken is ERC20, Ownable {
uint256 public maxSupply = 1\_000\_000 \* 1e18;

```
address public daoTreasury;
address public teamVestingWallet;
address public partnersVestingWallet;
address public marketingWallet;
address public saleWallet;

uint256 public totalDividends;
uint256 public dividendsPerToken; // exprimé en 1e18
mapping(address => uint256) public withdrawnDividends;
mapping(address => uint256) public lastDividendsPerToken;

event DividendsReceived(uint256 amount);
event DividendsClaimed(address indexed user, uint256 amount);
event MaxSupplyUpdated(uint256 newMaxSupply);

constructor(
    address _daoTreasury,
    address _teamVestingWallet,
    address _partnersVestingWallet,
    address _marketingWallet,
    address _saleWallet
) ERC20("HorseToken", "HRTK") {
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

    _mint(_saleWallet, 500_000 * 1e18);
    _mint(_daoTreasury, 200_000 * 1e18);
    _mint(_teamVestingWallet, 150_000 * 1e18);
    _mint(_partnersVestingWallet, 100_000 * 1e18);
    _mint(_marketingWallet, 50_000 * 1e18);
}

receive() external payable {
    require(totalSupply() > 0, "No holders");
    require(msg.value > 0, "No ETH sent");

    dividendsPerToken += (msg.value * 1e18) / totalSupply();
    totalDividends += msg.value;

    emit DividendsReceived(msg.value);
}

function calculateOwed(address account) public view returns (uint256) {
    uint256 owed = ((dividendsPerToken - lastDividendsPerToken[account]) * balanceOf(account)) / 1e18;
    return owed;
}

function claimDividends() external {
    uint256 owed = calculateOwed(msg.sender);
    require(owed > 0, "No dividends available");

    withdrawnDividends[msg.sender] += owed;
    lastDividendsPerToken[msg.sender] = dividendsPerToken;
    payable(msg.sender).transfer(owed);

    emit DividendsClaimed(msg.sender, owed);
}

function burn(uint256 amount) external {
    _burn(msg.sender, amount);
}

function updateMaxSupply(uint256 newMaxSupply) external onlyOwner {
    require(newMaxSupply > maxSupply, "New max supply must be greater");
    maxSupply = newMaxSupply;
    emit MaxSupplyUpdated(newMaxSupply);
}

function mint(address to, uint256 amount) external onlyOwner {
    require(totalSupply() + amount <= maxSupply, "Exceeds max supply");
    _mint(to, amount);
}
```

}

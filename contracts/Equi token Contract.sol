// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract EquiToken is ERC20, Ownable {
    using Address for address;

    uint256 public constant MAX_SUPPLY = 1_000_000 * 1e18;

    address public daoTreasury;
    address public teamVestingWallet;
    address public partnersVestingWallet;
    address public marketingWallet;
    address public saleWallet;

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

        _mint(_saleWallet, 500_000 * 1e18);            // 50%
        _mint(_daoTreasury, 200_000 * 1e18);           // 20%
        _mint(_teamVestingWallet, 150_000 * 1e18);     // 15%
        _mint(_partnersVestingWallet, 100_000 * 1e18); // 10%
        _mint(_marketingWallet, 50_000 * 1e18);        // 5%
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}

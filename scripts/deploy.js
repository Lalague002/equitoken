// scripts/deploy.js
const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Déploiement avec le compte:", deployer.address);

  const initialSupply = ethers.utils.parseEther("1000000");

  // Remplace ces adresses par celles que tu veux utiliser
  const daoTreasury = "0xDAO_ADDRESS";
  const teamVestingWallet = "0xTEAM_ADDRESS";
  const partnersVestingWallet = "0xPARTNER_ADDRESS";
  const marketingWallet = "0xMARKETING_ADDRESS";
  const saleWallet = "0xSALE_ADDRESS";

  const EquiToken = await ethers.getContractFactory("EquiToken");
  const token = await EquiToken.deploy(
    daoTreasury,
    teamVestingWallet,
    partnersVestingWallet,
    marketingWallet,
    saleWallet
  );

  await token.deployed();
  console.log("EquiToken déployé à:", token.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

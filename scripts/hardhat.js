// scripts/deploy.js
const hre = require("hardhat");

async function main() {
  const EquiToken = await hre.ethers.getContractFactory("EquiToken");

  const token = await EquiToken.deploy(
    "0xDAO_TREASURY_ADDRESS",
    "0xTEAM_VESTING_WALLET",
    "0xPARTNERS_VESTING_WALLET",
    "0xMARKETING_WALLET",
    "0xSALE_WALLET"
  );

  await token.deployed();
  console.log(`EquiToken déployé à l’adresse : ${token.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

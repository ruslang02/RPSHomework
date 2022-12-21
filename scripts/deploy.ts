import { BigNumber } from "ethers";
import { ethers } from "hardhat";

async function main() {
  const RPSHomework = await ethers.getContractFactory("RPSHomework");
  const contract = await RPSHomework.deploy();

  await contract.deployed();

  console.log(`RPSHomework deployed to ${contract.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

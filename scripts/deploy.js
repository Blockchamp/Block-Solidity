// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');
  /* const Token = await hre.ethers.getContractFactory("NestToken");
  const token = await Token.deploy();

  await token.deployed();

  console.log("Token deployed to:", token.address); */
  // We get the contract to deploy
  const Payment = await hre.ethers.getContractFactory("Payment");
  const payment = await Payment.deploy(
    "0xD2668EF608D7D865FD16308A2f38fc3d15024Ff0"
  );

  await payment.deployed();

  console.log("Payment deployed to:", payment.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

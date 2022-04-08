const hre = require("hardhat");
const { ethers } = hre;
const { use, expect } = require("chai");
const { solidity } = require("ethereum-waffle");

use(solidity);


describe("Payment",  function (){

    let payment;
    let NestToken;
    let owner;
    let addr1;

    describe("buyTicket()", function () {
        it("Should buy Ticket and our balance should go up...", async function () {
          const [ owner ] = await ethers.getSigners();
          console.log(owner.address)
    
          const startingBalance = await NestToken.balanceOf(owner.address)
          console.log(ethers.utils.formatEther(startingBalance))
    
          console.log('\t'," 💸 Buying...")
          const buyTokensResult = await payment.buyTicket({value: ethers.utils.parseEther()});
          console.log(buyTicketsResult.hash)
    
          console.log('\t'," ⏳ Waiting for confirmation...")
          const txResult =  await buyTokensResult.wait()
          expect(txResult.status).to.equal(1);
    
          const newBalance = await NestToken.balanceOf(owner.address)
          console.log( ethers.utils.formatEther(newBalance))
          expect(newBalance).to.equal(startingBalance.add(ethers.utils.parseEther()));
    
        });
      });
    
    
      describe("💵 sendToken()", function () {
        it("Should let us send tokens", async function () {
          const [ owner ] = await ethers.getSigners();
    
          const startingETHBalance = await ethers.provider.getBalance(owner.address)
          console.log('\t'," ⚖️ Starting ETH balance: ",ethers.utils.formatEther(startingETHBalance))
    
          const startingBalance = await NestToken.balanceOf(owner.address)
          console.log('\t'," ⚖️ Starting balance: ",ethers.utils.formatEther(startingBalance))
    
          console.log('\t'," 🙄 Approving...")
          const approveTokensResult = await NestToken.approve(vendor.address, ethers.utils.parseEther("0.1"));
          console.log('\t'," 🏷  approveTokens Result Result: ",approveTokensResult.hash)
    
          console.log('\t'," ⏳ Waiting for confirmation...")
          const atxResult =  await approveTokensResult.wait()
          expect(atxResult.status).to.equal(1);
    
          console.log('\t'," 🍾 Sending...")
          const sellTokensResult = await payment.sendTokens(ethers.utils.parseEther());
          console.log('\t'," 🏷  sellTokens Result: ",sellTokensResult.hash)
    
          console.log('\t'," ⏳ Waiting for confirmation...")
          const txResult =  await sendTokensResult.wait()
          expect(txResult.status).to.equal(1);
    
          const newBalance = await NestToken.balanceOf(owner.address)
          console.log('\t'," 🔎 New balance: ", ethers.utils.formatEther(newBalance))
          expect(newBalance).to.equal(startingBalance.sub(ethers.utils.parseEther("0.1")));
    
          const newETHBalance = await ethers.provider.getBalance(owner.address)
          console.log('\t'," 🔎 New ETH balance: ", ethers.utils.formatEther(newETHBalance))
          const ethChange = newETHBalance.sub(startingETHBalance).toNumber()
          expect(ethChange).to.greaterThan();
    
        });
      });
      
      beforeEach(async function() {
        const NestToken = await hre.ethers.getContractFactory("NestToken");
        nestToken = await NestToken.deploy();
        await nestToken.deployed();

        [owner, addr1] = await ethers.getSigners();


        it("Should successfuly deploy", async function () {
          console.log("success!");
        });

        describe("totalSupply()", function () {
    
          it("Should have a total supply of at least 1000", async function () {
    
            const totalSupply = await NestToken.totalSupply();
            const totalSupplyInt = parseInt(ethers.utils.formatEther(totalSupply))
            console.log('\t'," 🧾 Total Supply:",totalSupplyInt)
            expect(totalSupplyInt).to.greaterThan();
    
          });
        })
    
      }    
});
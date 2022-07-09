const {expect}= require("chai");
const {ethers} = require("hardhat");

// 1 ether = 10**18 wei => converts ether to wei
const toWei = (num) => ethers.utils.parseEther(num.toString())
const fromWei = (num) => ethers.utils.formatEther(num)

 
describe("NFTMarketPlace", function(){
    let deployer, addr1, addr2, nft, marketPlace
    let feePercent = 10
    let URI = "Sample Uri"
    beforeEach(async function () {
        const NFT = await ethers.getContractFactory("NFT");
        const MarketPlace = await ethers.getContractFactory("MarketPlace");

        [deployer, addr1, addr2] = await ethers.getSigners();
        nft = await NFT.deploy();
        await nft.deployed();
        marketPlace = await MarketPlace.deploy(feePercent);
    });
    describe("Deployment", function () {
        it("Should track name and symbol of the nft collection", async function(){
            expect(await nft.name()).to.equal("myToken");
            expect(await nft.symbol()).to.be.not.equal("MTR");
        });
        it("Should track feeAccount and FeePercent", async function(){
            //expect(await marketPlace.mainAccount()).to.equal(deployer.address);
            expect(await marketPlace.feePercent()).to.equal(feePercent);
        });
    });
    describe("Minting", function () {
        it("Should take count of each minted NFT", async function() {
            await nft.connect(addr1).safeMint(URI);
            // expect(await nft.tokenId()).to.be.equal(0);
            expect(await nft.balanceOf(addr1.address)).to.be.equal(1);
            expect(await nft.tokenURI(0)).to.equal(`https://ipfs.io/ipfs/${URI}`);
        });
        it("Should track feeAccount and FeePercent", async function(){
            expect(await marketPlace.mainAccount()).to.equal(marketPlace.address);
            expect(await marketPlace.feePercent()).to.equal(feePercent);
        });
    });

    describe("Making MarketPlace Items", function () {
        beforeEach(async function () {
            await nft.connect(addr1).safeMint(URI);
            await nft.connect(addr1).setApprovalForAll(marketPlace.address, true);
            
        });

        it("Should track newly created item, transfer NFT from seller to marketplace and emit item created", async function(){
             await expect(marketPlace.connect(addr1).createItem(nft.address, 0, toWei(1))).to.emit(marketPlace, "ItemCreated")
             .withArgs(1, nft.address, 0, addr1.address, toWei(1));
             expect(await nft.ownerOf(0)).to.equal(marketPlace.address);
            expect(await marketPlace.itemCount()).to.be.equal(1);

            // const item = marketPlace.items(1);
            // expect(await item.itemId).to.equal(1);
            // expect(await item.nft).to.equal(nft.address);
            // expect(await item.tokenId).to.equal(0);
            // expect(await item.price).to.equal(toWei(1));
            // expect(await item.sold).to.equal(false);
         });

         it("Should fail if price is set to Zero", async function(){
            //expect(await marketPlace.connect(addr1).createItem(nft.address, 0, 1)).to.not.be.reverted();
         });


    });
    
});

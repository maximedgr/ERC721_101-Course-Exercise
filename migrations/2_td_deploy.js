const Str = require('@supercharge/strings')

var TDErc721 = artifacts.require("ERC721TD.sol");



module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        await deployTD721Token(deployer, network, accounts);  
        await deployRecap(deployer,network,accounts);
    });
};

async function deployTD721Token(deployer, network, accounts) {
	TDTokenERC721 = await TDErc721.new()	
}

async function deployRecap(deployer, network, accounts) {
	console.log("TDTokenERC721 : " + TDTokenERC721.address)
}


//Nb : truffle migrate --f 2 --to 2 --network goerli --skip-dry-run
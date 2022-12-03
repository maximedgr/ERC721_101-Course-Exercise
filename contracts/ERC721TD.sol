pragma solidity ^0.6.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./IExerciceSolution.sol";

contract ERC721TD is ERC721, IExerciceSolution {
    using Counters for Counters.Counter;
    address public owner;
    Counters.Counter private _tokenIdCounter;

    struct Parents{
        uint256 idParents1;
        uint256 idParents2;
    }


    mapping(uint256=> string) public idName;
    mapping(uint256=> uint256) public idLegs;
    mapping(uint256=> uint256) public idSex;
    mapping(uint256=> bool) public idWings;
    mapping(address=>bool) public breederList;
    mapping(uint256=>address) public idToOwner;
    mapping(uint256=>bool)public idForSale;
    mapping(uint256=>uint256)public idPrice;
    mapping(uint256=>bool)public idReproduce;
    mapping(uint256=>uint256)public idReproducePrice;

    mapping(address=>bool) public breederlist;
    mapping(uint256=>address) public idAuthorizedBreeder;
    mapping(uint256=>bool) public idAlive;

    mapping(uint256=>Parents) public idParents;

    
    constructor() public ERC721("Krkmu", "KRK") {
        owner=msg.sender;
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        ERC721._mint(0x0E4F5184E6f87b5F959aeE5a09a2797e8B1b20E5,tokenId);
        breederList[address(0x0E4F5184E6f87b5F959aeE5a09a2797e8B1b20E5)]=true;
        idName[tokenId]= "jGVCEY3tnQQx-z_";
        idLegs[tokenId]=3;
        idSex[tokenId]=1;
        idWings[tokenId]=true;
        idAlive[tokenId]=true;
        idToOwner[tokenId]=address(0x0E4F5184E6f87b5F959aeE5a09a2797e8B1b20E5);
        idForSale[tokenId]=false;
        idPrice[tokenId]=0;
        idReproduce[tokenId]=false;
        idReproducePrice[tokenId]=0;

        tokenId = _tokenIdCounter.current();
        ERC721._mint(msg.sender,tokenId);
        idForSale[tokenId]=true;
        idPrice[tokenId]=0.0001 ether;
        idToOwner[tokenId]=msg.sender;
        idReproduce[tokenId]=true;
        idReproducePrice[tokenId]=0.0001 ether;
        breederList[msg.sender]=true;
        _tokenIdCounter.increment();
    //P1
        tokenId = _tokenIdCounter.current();
        ERC721._mint(msg.sender,tokenId);
        idForSale[tokenId]=true;
        idPrice[tokenId]=0.0001 ether;
        idToOwner[tokenId]=msg.sender;
        idReproduce[tokenId]=false;
        idReproducePrice[tokenId]=0;
        _tokenIdCounter.increment();
    //P2
        tokenId = _tokenIdCounter.current();
        ERC721._mint(msg.sender,tokenId);
        idForSale[tokenId]=true;
        idPrice[tokenId]=0.0001 ether;
        idToOwner[tokenId]=msg.sender;
        idReproduce[tokenId]=false;
        idReproducePrice[tokenId]=0;
        _tokenIdCounter.increment();
        
    }

    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }

    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mint(to, tokenId);
    }

    // Breeding function
	function isBreeder(address account) external override returns (bool){
        return breederList[account];
    }

	function registrationPrice() external override returns (uint256){
        return 0;
    }

	function registerMeAsBreeder() external override payable{
        require(!breederList[msg.sender]);
        breederList[msg.sender]=true;
    }

	function declareAnimal(uint sex, uint legs, bool wings, string calldata name) external override returns (uint256){
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        idName[tokenId]= name;
        idLegs[tokenId]=legs;
        idSex[tokenId]=sex;
        idWings[tokenId]=wings;
        idAlive[tokenId]=true;
        idToOwner[tokenId]=msg.sender;
        idReproducePrice[tokenId]=0;
        idReproduce[tokenId]=false;
        ERC721._mint(msg.sender,tokenId);
        return tokenId;
    }

	function getAnimalCharacteristics(uint animalNumber) external override returns (string memory _name, bool _wings, uint _legs, uint _sex){
        return (idName[animalNumber],idWings[animalNumber],idLegs[animalNumber],idSex[animalNumber]);
    }

	function declareDeadAnimal(uint animalNumber) external override{
        require(idToOwner[animalNumber]==msg.sender,"Not your animal");
        idAlive[animalNumber]=false;
        idName[animalNumber]= "";
        idLegs[animalNumber]=0;
        idSex[animalNumber]=0;
        idWings[animalNumber]=false;
        idReproduce[animalNumber]=false;
        _burn(animalNumber);
    }

	function tokenOfOwnerByIndex(address owner, uint256 index) public override(IExerciceSolution,ERC721) view returns (uint256){
        require(balanceOf(owner)!=0,"you don't have token");
        return ERC721.tokenOfOwnerByIndex(owner,index);
    }

	// Selling functions
	function isAnimalForSale(uint animalNumber) external view override returns (bool){
        return idForSale[animalNumber];
    }

	function animalPrice(uint animalNumber) external view override returns (uint256){
        return idPrice[animalNumber];
    }

	function buyAnimal(uint animalNumber) external payable override{
        require(idForSale[animalNumber],"This animal can not be buy");
        require(msg.value>=idPrice[animalNumber],"not enought money bro");
        _transfer(idToOwner[animalNumber], msg.sender, animalNumber);
    }

	function offerForSale(uint animalNumber, uint price) external override{
        require(idToOwner[animalNumber]==msg.sender,"you can not offer for sale a animal you don't own");
        idForSale[animalNumber]=true;
        idPrice[animalNumber]=price;
    }

	// Reproduction functions

	function declareAnimalWithParents(uint sex, uint legs, bool wings, string calldata name, uint parent1, uint parent2) external override returns (uint256){
        require(idAuthorizedBreeder[parent2]==msg.sender);
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        idName[tokenId]= name;
        idLegs[tokenId]=legs;
        idSex[tokenId]=sex;
        idWings[tokenId]=wings;
        idAlive[tokenId]=true;
        idToOwner[tokenId]=msg.sender;
        idParents[tokenId].idParents1=parent1;
        idParents[tokenId].idParents2=parent2;
        idReproduce[tokenId]=false;
        idReproducePrice[tokenId]=0;
        ERC721._mint(msg.sender,tokenId);
        idAuthorizedBreeder[parent2]=address(0);
        return tokenId;
    }

	function getParents(uint animalNumber) external override returns (uint256, uint256){
        return (idParents[animalNumber].idParents1,idParents[animalNumber].idParents2);
    }

	function canReproduce(uint animalNumber) external override returns (bool){
        return idReproduce[animalNumber];
    }

	function reproductionPrice(uint animalNumber) external override view returns (uint256){
        return idReproducePrice[animalNumber];
    }

	function offerForReproduction(uint animalNumber, uint priceOfReproduction) external override returns (uint256){
        require(ownerOf(animalNumber)==msg.sender);
        idReproducePrice[animalNumber]=priceOfReproduction;
        idReproduce[animalNumber]=true;
        return animalNumber;
    }

	function authorizedBreederToReproduce(uint animalNumber) external override returns (address){
        return idAuthorizedBreeder[animalNumber];
    }

	function payForReproduction(uint animalNumber) external override payable{
        require(msg.value>=idReproducePrice[animalNumber]);
        idAuthorizedBreeder[animalNumber]=msg.sender;
    }


}
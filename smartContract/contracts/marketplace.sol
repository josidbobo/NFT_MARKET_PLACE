// SPDX-License-Identifier: MIT
pragma solidity = 0.8.4;

import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; 
import "@openzeppelin/contracts/utils/Counters.sol";

contract MarketPlace is ReentrancyGuard {
    using Counters for Counters.Counter;

    address payable public mainAccount = payable(address(this));
    uint public immutable feePercent;
    Counters.Counter public itemCount;

    struct Item{
        uint256 itemId;
        IERC721 nft;
        uint tokenId;
        uint price;
        address payable seller;
        bool sold;
    }
    event ItemCreated(uint itemId, address indexed nft, uint tokenId, address indexed owner, uint price);

    mapping(uint=>Item) public items;

    modifier noZeroAddress(){
        require(msg.sender != address(0));
        _;
    }

    constructor(uint _feePercent){
        feePercent = _feePercent;
    }

    function create(IERC721 _nft, uint _tokenId, uint _price) external nonReentrant noZeroAddress{
        require(_price != 0, "Price must be greater than zero");

        itemCount.increment();
        uint count = itemCount.current();
        _nft.transferFrom(msg.sender, address(this), _tokenId);

        items[count] = Item (count, _nft, _tokenId, _price, payable(msg.sender), false);
        emit ItemCreated(count, address(_nft), _tokenId, msg.sender, _price);

    }

    // function buy(uint _tokenID,) external nonReentrant noZeroAddress{

    // }
}

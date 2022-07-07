// SPDX-License-Identifier: MIT
pragma solidity = 0.8.4;

import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; 
import "@openzeppelin/contracts/utils/Counters.sol";

contract MarketPlace is ReentrancyGuard {
    using Counters for Counters.Counter;
    IERC721 _nft;

    address payable public mainAccount = payable(address(this));
    uint public immutable feePercent;
    Counters.Counter public itemCount;

    modifier noZeroAddress(){
        require(msg.sender != address(0));
        _;
    }

    constructor(uint _feePercent){
        feePercent = _feePercent;
    }

}

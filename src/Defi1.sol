// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "./Token.sol";
import "forge-std/console.sol";

contract DeFi1 {
    address[] public investors;
    uint256 public initialAmount;
    uint256 public blockReward;
    Token public token;

    constructor(uint256 _initialAmount, uint256 _blockReward) {
        initialAmount = _initialAmount;
        token = new Token(_initialAmount);
        blockReward = _blockReward;
    }

    function addInvestor(address _investor) public {
        investors.push(_investor);
    }

    function claimTokens() public {
        bool found;
        uint256 payout;

        for (uint256 ii = 0; ii < investors.length; ii++) {
            if (investors[ii] == msg.sender) {
                found = true;
                break;
            }
        }
        if (found == true) {
            payout = calculatePayout();
        }
        token.transfer(msg.sender, payout);
    }

    function calculatePayout() public returns (uint256 _payout) {
        uint256 _blockReward = block.number % 1000;
        uint256 _payoutShare = initialAmount / investors.length;
        _payout = _payoutShare * _blockReward;
        blockReward--;
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Vm.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/DeFi1.sol";
import "../src/Token.sol";

contract ContractTest is Test {
    DeFi1 public defi;
    Token public token;

    address[3] public users;
    uint256 internal constant initialAmount = 1000;
    uint256 internal constant blockReward = 5;

    function setUp() public {
        defi = new DeFi1(initialAmount, blockReward);
        token = Token(defi.token());
        users = [makeAddr("alice"), makeAddr("bob"), makeAddr("carol")];
    }

    function _testClaim(uint256 _skipBlocks) internal {
        defi.addInvestor(users[0]);
        defi.addInvestor(users[1]);
        uint256 _initialBalance = token.balanceOf(users[0]);
        vm.roll(block.number + _skipBlocks);
        uint256 _expectedPayout = (initialAmount / 2) * (block.number % 1000);
        vm.prank(users[0]);
        defi.claimTokens();
        uint256 _finalBalance = token.balanceOf(users[0]);
        assertEq(_finalBalance - _initialBalance, _expectedPayout);
    }

    function testClaim() public {
        _testClaim(1);
    }

    // function testClaimFuzz(uint256 _skipBlocks) public {
    //     vm.assume(_skipBlocks > 0);
    //     _testClaim(_skipBlocks);
    // }

    function testInitialBalance() public {}

    function testAddInvestor() public {
        defi.addInvestor(users[0]);
        assertEq(defi.investors(0), users[0]);
    }

    function testCorrectPayoutAmount() public {}

    function testAddingManyInvestors() public {}

    function testAddingManyInvestorsAndClaiming() public {}
}

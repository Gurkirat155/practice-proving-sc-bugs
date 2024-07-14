// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {HandlerStatefulFuzzCatches} from "../../../src/invariant-break/HandlerStatefulFuzzCatches.sol";
import {MockUSDC} from "../../mocks/MockUSDC.sol";
import {MockWETH} from "../../mocks/MockWETH.sol";
import {YeildERC20} from "../../mocks/YeildERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract HandlerStatefulFuzzCatchesTest is StdInvariant, Test {

    HandlerStatefulFuzzCatches hstffc;
    MockUSDC usdc;
    MockWETH weth;
    YeildERC20 yeild;

    IERC20[] supportedTokens;
    address owner = makeAddr("owner");

    uint256 public startingValue;


    function setUp() public {
        vm.startPrank(owner);
        yeild = new YeildERC20();
        supportedTokens.push(yeild);
        startingValue = yeild.INITIAL_SUPPLY();

        usdc = new MockUSDC();
        usdc.mint(owner, yeild.INITIAL_SUPPLY());
        supportedTokens.push(usdc);

        weth = new MockWETH();
        weth.mint(owner, yeild.INITIAL_SUPPLY());
        supportedTokens.push(weth);

        vm.stopPrank();

        hstffc = new HandlerStatefulFuzzCatches(supportedTokens);
        targetContract(address(hstffc));

    }

    function testStartingAmountSame() public view {
        assertEq(yeild.balanceOf(address(owner)), startingValue);
        assertEq(usdc.balanceOf(address(owner)), startingValue);
        assertEq(weth.balanceOf(address(owner)), startingValue);
    }

    // function statefulFuzz_testInvariant() public {

    //     // console.log("Starting balances" , yeild.balanceOf(address(hstffc)));
    //     // console.log("Starting balances" , yeild.balanceOf(address(owner)));

    //     vm.startPrank(owner);
    //     hstffc.withdrawToken(usdc);
    //     hstffc.withdrawToken(weth);
    //     hstffc.withdrawToken(yeild);
    //     vm.stopPrank();

    //     // console.log("Ending balances" , yeild.balanceOf(address(owner)));
    //     // assertEq(yeild.balanceOf(address(owner)), 0);
    //     // assertEq(usdc.balanceOf(address(owner)), 0);
    //     // assertEq(weth.balanceOf(address(owner)), 0);

    // }
    
}
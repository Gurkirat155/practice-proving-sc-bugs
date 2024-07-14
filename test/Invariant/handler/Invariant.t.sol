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
import {Handler} from "./Handler.t.sol";


contract HandlerStatefulFuzzCatchesTest is StdInvariant, Test {

    HandlerStatefulFuzzCatches hstffc;
    MockUSDC usdc;
    MockWETH weth;
    YeildERC20 yeild;
    Handler handler;

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

        handler = new Handler(hstffc, usdc, weth, yeild, owner);

        // targetContract(address(hstffc));
        bytes4[] memory selectors = new bytes4[](6);

        selectors[0] = handler.depositYeild.selector;
        selectors[3] = handler.withdrawYeild.selector;
        selectors[1] = handler.depositUSDC.selector;
        selectors[4] = handler.withdrawUSDC.selector;
        selectors[2] = handler.depositWETH.selector;
        selectors[5] = handler.withdrawWETH.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
        targetContract(address(handler));
    }

    function testStartingAmountSame() public view {
        assertEq(yeild.balanceOf(address(owner)), startingValue);
        assertEq(usdc.balanceOf(address(owner)), startingValue);
        assertEq(weth.balanceOf(address(owner)), startingValue);
    }


    // Below is the test that is failing, which is the bug that we found in yielderc20 contract and with minimum reverts

    function statefulFuzz_testInvariant() public {

        // console.log("Starting balances" , yeild.balanceOf(address(hstffc)));
        // console.log("Starting balances" , yeild.balanceOf(address(owner)));
        console.log("Address of yield", address(yeild));
        console.log("Address of usdc", address(usdc));
        console.log("Address of weth", address(weth));
        console.log("Address of owner", address(owner));
        console.log("Address of hstffc", address(hstffc));
        console.log("Address of handler", address(handler));
        console.log("Address of msg.sender", (msg.sender));

//   Address of yield 0x88F59F8826af5e695B13cA934d6c7999875A9EeA
//   Address of usdc 0xCeF98e10D1e80378A9A74Ce074132B66CDD5e88d
//   Address of weth 0x72cC13426cAfD2375FFABE56498437927805d3d2
//   Address of owner 0x7c8999dC9a822c1f0Df42023113EDB4FDd543266
//   Address of hstffc 0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
//   Address of handler 0x2e234DAe75C793f67A35089C9d99245E1C58470b
//   Address of msg.sender 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38

// 0xfA88c588d4E1c0cAe82C64a85861780071e83E43
        vm.startPrank(owner);
        hstffc.withdrawToken(usdc);
        hstffc.withdrawToken(weth);
        hstffc.withdrawToken(yeild);
        vm.stopPrank();

        // console.log("Ending balances" , yeild.balanceOf(address(owner)));
        // assertEq(yeild.balanceOf(address(owner)), 0);
        // assertEq(usdc.balanceOf(address(owner)), 0);
        // assertEq(weth.balanceOf(address(owner)), 0);

        assertEq(usdc.balanceOf(address(hstffc)),0);
        assertEq(weth.balanceOf(address(hstffc)),0);
        assertEq(yeild.balanceOf(address(hstffc)),0);

        assertEq(usdc.balanceOf(owner),startingValue);
        assertEq(weth.balanceOf(owner),startingValue);
        assertEq(yeild.balanceOf(owner),startingValue);

    }
    
}
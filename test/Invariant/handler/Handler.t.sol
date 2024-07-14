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


contract Handler is Test {

    HandlerStatefulFuzzCatches hstffc;
    MockUSDC usdc;
    MockWETH weth;
    YeildERC20 yeild;
    address owner ;

    constructor (HandlerStatefulFuzzCatches _hstffc, MockUSDC _usdc, MockWETH _weth, YeildERC20 _yeild,address _owner) {
        hstffc = _hstffc;
        usdc = _usdc;
        weth = _weth;
        yeild = _yeild;
        owner = _owner;
    }

    function depositYeild(uint256 _amount) public {
        uint256 amount = bound(_amount,0 , yeild.balanceOf(owner)); //'Bound' is a function that returns the value of the first argument, but bounded between the second and third arguments.
        vm.startPrank(owner);
        yeild.approve(address(hstffc), amount);
        hstffc.depositToken(yeild, amount);
        vm.stopPrank();
    }

    function depositUSDC(uint256 _amount) public {
        uint256 amount = bound(_amount,0 , usdc.balanceOf(owner));
        vm.startPrank(owner);
        usdc.approve(address(hstffc), amount);
        hstffc.depositToken(usdc, amount);
        vm.stopPrank();
    }

    function depositWETH(uint256 _amount) public {
        uint256 amount = bound(_amount,0 , weth.balanceOf(owner));
        vm.startPrank(owner);
        weth.approve(address(hstffc), amount);
        hstffc.depositToken(weth, amount);
        vm.stopPrank();
    }

    function withdrawYeild() public {
        vm.startPrank(owner);
        hstffc.withdrawToken(yeild);
        vm.stopPrank();
    }

    function withdrawUSDC() public {
        vm.startPrank(owner);
        hstffc.withdrawToken(usdc);
        vm.stopPrank();
    }

    function withdrawWETH() public {
        vm.startPrank(owner);
        hstffc.withdrawToken(weth);
        vm.stopPrank();
    }

}
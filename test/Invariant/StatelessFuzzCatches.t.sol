// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {StatelessFuzzCatches} from "../../src/invariant-break/StatelessFuzzCatches.sol";



contract StatelessFuzzCatchesTest is Test {
    
    StatelessFuzzCatches sfc;

    function setUp() public {
        sfc = new StatelessFuzzCatches();
    }

    function testFuzzStateless(uint128 myNumber) public view {
        assert(sfc.doMath(myNumber) != 0);
    }
    
}
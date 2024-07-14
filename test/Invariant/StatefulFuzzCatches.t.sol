// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {StatefulFuzzCatches} from "../../src/invariant-break/StatefulFuzzCatches.sol";

contract StatefulFuzzCatchesTest is StdInvariant, Test {

    StatefulFuzzCatches stffc;

    function setUp() public {
        stffc = new StatefulFuzzCatches();
        targetContract(address(stffc));
    }

    function testFuzzStatelessDoMoreMath(uint128 myNumber) public {
        assert(stffc.doMoreMathAgain(myNumber) != 0);
    }

    function statefulFuzz_catches() public view{
        assert(stffc.storedValue() != 0);
    }

    
}
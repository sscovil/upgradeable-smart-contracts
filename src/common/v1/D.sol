// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { Bv1 } from "src/common/v1/B.sol";
import { Cv1 } from "src/common/v1/C.sol";

abstract contract Dv1 is Bv1, Cv1 {
    uint256 public d;

    function initialize(uint256 _a, uint256 _b, uint256 _c, uint256 _d) public initializer {
        __D_init(_a, _b, _c, _d);
    }

    function __D_init(uint256 _a, uint256 _b, uint256 _c, uint256 _d) internal onlyInitializing {
        __A_init(_a); // Initialize A once
        __B_init_unchained(_b); // B's local state only
        __C_init_unchained(_c); // C's local state only
        __D_init_unchained(_d); // D's local state
    }

    function __D_init_unchained(uint256 _d) internal onlyInitializing {
        d = _d;
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { Av1 } from "src/common/v1/A.sol";

abstract contract Bv1 is Av1 {
    uint256 public b;

    function __B_init(uint256 _a, uint256 _b) internal onlyInitializing {
        __A_init(_a); // Initialize parent
        __B_init_unchained(_b);
    }

    function __B_init_unchained(uint256 _b) internal onlyInitializing {
        b = _b;
    }
}

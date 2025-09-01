// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { Av1 } from "src/common/v1/A.sol";

abstract contract Cv1 is Av1 {
    uint256 public c;

    function __C_init(uint256 _a, uint256 _c) internal onlyInitializing {
        __A_init(_a); // Initialize parent
        __C_init_unchained(_c);
    }

    function __C_init_unchained(uint256 _c) internal onlyInitializing {
        c = _c;
    }
}

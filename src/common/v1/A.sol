// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { UUPSUpgradeable } from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

abstract contract Av1 is Initializable, UUPSUpgradeable {
    uint256 public a;

    function __A_init(uint256 _a) internal onlyInitializing {
        __A_init_unchained(_a);
    }

    function __A_init_unchained(uint256 _a) internal onlyInitializing {
        a = _a;
    }
}

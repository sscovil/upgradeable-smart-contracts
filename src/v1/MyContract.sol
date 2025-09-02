// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { BaseTest } from "test/BaseTest.sol";
import { Dv1 } from "src/common/v1/D.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract MyContractV1 is Dv1, OwnableUpgradeable {
    uint256 public constant VERSION = 1;
    uint256 public e;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner, uint256 _a, uint256 _b, uint256 _c, uint256 _d)
        public
        virtual
        initializer
    {
        __MyContractV1_init(initialOwner, _a, _b, _c, _d);
    }

    function __MyContractV1_init(address initialOwner, uint256 _a, uint256 _b, uint256 _c, uint256 _d)
        internal
        onlyInitializing
    {
        __Ownable_init(initialOwner);
        __D_init(_a, _b, _c, _d);
        __MyContractV1_init_unchained(_a, _b, _c, _d);
    }

    function __MyContractV1_init_unchained(uint256 _a, uint256 _b, uint256 _c, uint256 _d) internal onlyInitializing {
        e = _a + _b + _c + _d;
    }

    function _authorizeUpgrade(address newImplementation) internal virtual override onlyOwner {
        // The onlyOwner modifier ensures only the owner can authorize upgrades; no additional logic required
    }
}

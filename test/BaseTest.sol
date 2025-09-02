// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Test } from "forge-std/Test.sol";
import { Upgrades } from "openzeppelin-foundry-upgrades/Upgrades.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @dev Base contract mixin to include common users for testing.
 */
abstract contract WithUsers is Test {
    address public owner;
    address internal unauthorizedAccount;

    address public alice;
    address public bob;
    address public carol;

    function _setUpUsers() internal {
        owner = makeAddr("owner");
        unauthorizedAccount = makeAddr("unauthorizedAccount");

        alice = makeAddr("alice");
        bob = makeAddr("bob");
        carol = makeAddr("carol");
    }
}

/**
 * @dev Base contract mixin to include upgradeable contract deployment and testing.
 * Inheriting contracts must implement the abstract methods to specify the contract name,
 * initializer data, and token type.
 */
abstract contract WithUpgrades is WithUsers {
    address internal proxy;

    /**
     * @dev Deploy the upgradeable contract proxy and initialize it.
     * Should be called in the `setUp` function of inheriting contracts.
     */
    function _deployContract() public virtual {
        proxy = Upgrades.deployUUPSProxy(_getContractName(), _getInitializerData());
        _setToken(proxy);
    }

    /**
     * @dev Upgrade the contract to a new implementation.
     * @param newImplementation The address of the new implementation contract.
     * @return success True if the upgrade was successful, false otherwise.
     */
    function _upgradeContract(address newImplementation) internal returns (bool) {
        (bool success,) = proxy.call(abi.encodeWithSignature("upgradeToAndCall(address,bytes)", newImplementation, ""));
        return success;
    }

    // ========== Abstract Methods To Be Implemented ==========

    /**
     * @dev Deploy and return a new implementation contract for upgrade testing.
     * Must be overridden by inheriting contracts to return the specific implementation.
     */
    function _deployNewImplementation() internal virtual returns (address);

    /**
     * @dev Get the contract name for deployment.
     * Must be overridden by inheriting contracts.
     */
    function _getContractName() internal view virtual returns (string memory);

    /**
     * @dev Get the initialization call data.
     * Must be overridden by inheriting contracts.
     */
    function _getInitializerData() internal view virtual returns (bytes memory);

    /**
     * @dev Set the token variable with the correct type.
     * Must be overridden by inheriting contracts to cast proxy to the specific token type.
     */
    function _setToken(address proxyAddress) internal virtual;

    // ========== Initialization and Upgrade Tests ==========

    /**
     * @dev Test that initialization succeeds with valid parameters.
     */
    function test_BaseTest_initialize() public virtual {
        // Deploy a new uninitialized implementation
        address implementation = _deployNewImplementation();

        // Get initialization data
        bytes memory initData = _getInitializerData();

        // Call initialize directly on the implementation
        (bool success,) = implementation.call(initData);
        assertTrue(success, "Initialization should succeed");

        // Verify the contract was initialized
        vm.expectRevert(abi.encodeWithSelector(Initializable.InvalidInitialization.selector));
        (success,) = implementation.call(initData);
    }

    /**
     * @dev Test that initializer reverts when called after initialization.
     */
    function testRevert_BaseTest_initialize_InvalidInitialization() public virtual {
        // Try to call the initializer again on the already initialized proxy
        bytes memory initData = _getInitializerData();

        // Expect revert due to already being initialized
        vm.startPrank(owner);
        bool success;
        vm.expectRevert(abi.encodeWithSelector(Initializable.InvalidInitialization.selector));
        (success,) = proxy.call(initData);
        vm.stopPrank();
    }

    /**
     * @dev Test that authorized upgrade succeeds.
     * Only applicable for contracts with UUPS upgradeability.
     */
    function test_BaseTest_authorizeUpgrade() public virtual {
        // Deploy new implementation
        address newImplementation = _deployNewImplementation();

        // Perform upgrade as owner (who has authorization)
        vm.startPrank(owner);
        bool success = _upgradeContract(newImplementation);
        vm.stopPrank();

        assertTrue(success, "Upgrade should succeed with proper authorization");
    }

    /**
     * @dev Test that unauthorized upgrade reverts.
     * Only applicable for contracts with UUPS upgradeability and access control.
     */
    function testRevert_BaseTest_authorizeUpgrade_Unauthorized() public virtual {
        // Deploy new implementation
        address newImplementation = _deployNewImplementation();

        // Try to upgrade as unauthorized user
        vm.startPrank(unauthorizedAccount);
        bool success;
        vm.expectRevert();
        success = _upgradeContract(newImplementation);
        vm.stopPrank();
    }
}

/**
 * @dev Base test harness for upgradeable contracts.
 */
abstract contract BaseTest is WithUpgrades {
    function setUp() public virtual {
        _setUpUsers();
        vm.prank(owner);
        _deployContract();
    }
}

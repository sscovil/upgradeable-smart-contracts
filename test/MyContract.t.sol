// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { MyContractV1 } from "src/v1/MyContract.sol";
import { MyContractV2 } from "src/v2/MyContract.sol";
import { BaseTest } from "test/BaseTest.sol";

contract MyContractV1Test is BaseTest {
    MyContractV1 internal v1;
    MyContractV2 internal v2;

    // =========== Test Setup ============ //

    function _deployNewImplementation() internal override returns (address) {
        return address(new MyContractV1());
    }

    function _getContractName() internal pure override returns (string memory) {
        return "MyContract.sol:MyContractV1";
    }

    function _getInitializerData() internal view override returns (bytes memory) {
        return abi.encodeCall(MyContractV1.initialize, (owner, 1, 2, 3, 4));
    }

    function _setToken(address proxyAddress) internal override {
        v1 = MyContractV1(proxyAddress);
    }

    // ============ Tests ============= //

    function test_D_initialize() public view {
        assertEq(v1.a(), 1);
        assertEq(v1.b(), 2);
        assertEq(v1.c(), 3);
        assertEq(v1.d(), 4);
    }

    function test_D_upgradeToV2() public {
        // Check version
        assertEq(v1.VERSION(), 1, "Initial version should be 1");

        // Deploy new implementation
        MyContractV2 newImplementation = new MyContractV2();

        // Upgrade to V2
        vm.startPrank(owner);
        bool success = _upgradeContract(address(newImplementation));
        vm.stopPrank();
        assertTrue(success, "Upgrade to V2 should succeed");

        // Cast proxy to V2
        v2 = MyContractV2(address(v1));

        // Verify the proxy address remains the same
        assertEq(address(v2), address(v1), "Proxy address should remain the same after upgrade");

        // Check new version
        assertEq(v2.VERSION(), 2, "Version should be updated to 2");

        // Verify state is preserved
        assertEq(v2.a(), 1);
        assertEq(v2.b(), 2);
        assertEq(v2.c(), 3);
        assertEq(v2.d(), 4);

        // Verify new functionality
        MyContractV2.Config memory config = v2.getConfig();
        assertEq(config.a, 1);
        assertEq(config.b, 2);
        assertEq(config.c, 3);
        assertEq(config.d, 4);

        // Update config
        vm.startPrank(owner);
        v2.setConfig(10, 20, 30, 40);
        vm.stopPrank();
        config = v2.getConfig();
        assertEq(config.a, 10);
        assertEq(config.b, 20);
        assertEq(config.c, 30);
        assertEq(config.d, 40);
    }
}

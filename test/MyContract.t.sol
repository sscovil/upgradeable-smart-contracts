// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { MyContractV1 } from "src/v1/MyContract.sol";
import { MyContractV2 } from "src/v2/MyContract.sol";
import { BaseTest } from "test/BaseTest.sol";

contract MyContractTest is BaseTest {
    MyContractV1 internal v1;

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

    function test_initialize() public view {
        assertEq(v1.a(), 1);
        assertEq(v1.b(), 2);
        assertEq(v1.c(), 3);
        assertEq(v1.d(), 4);
        assertEq(v1.e(), 10); // e = a + b + c + d
    }

    function test_upgradeToV2() public {
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
        MyContractV2 v2 = MyContractV2(address(v1));

        // Verify the proxy address remains the same
        assertEq(address(v2), address(v1), "Proxy address should remain the same after upgrade");

        // Check new version
        assertEq(v2.VERSION(), 2, "Version should be updated to 2");

        // Verify state is preserved
        assertEq(v2.a(), 1);
        assertEq(v2.b(), 2);
        assertEq(v2.c(), 3);
        assertEq(v2.d(), 4);
        assertEq(v2.e(), 10); // e = a + b + c + d

        // Verify new functionality
        MyContractV2.Config memory config = v2.getConfig();
        assertEq(config.a, 1);
        assertEq(config.b, 2);
        assertEq(config.c, 3);
        assertEq(config.d, 4);
        assertEq(v2.e(), 10);

        // Update config
        vm.startPrank(owner);
        v2.setConfig(10, 20, 30, 40);
        vm.stopPrank();
        config = v2.getConfig();
        assertEq(config.a, 10);
        assertEq(config.b, 20);
        assertEq(config.c, 30);
        assertEq(config.d, 40);
        assertEq(v2.e(), 100); // e = a + b + c + d
    }
}

contract MockV1 is MyContractV1 {
    function initialize(address initialOwner, uint256 _a, uint256 _b, uint256 _c, uint256 _d)
    public
    override
    initializer
    {
        __MyContractV1_init(initialOwner, _a * 2, _b * 2, _c * 2, _d * 2);
    }
}

contract MockV1Test is BaseTest {
    MockV1 internal mockV1;

    // =========== Test Setup ============ //

    function _deployNewImplementation() internal override returns (address) {
        return address(new MockV1());
    }

    function _getContractName() internal pure override returns (string memory) {
        return "MyContract.t.sol:MockV1";
    }

    function _getInitializerData() internal view override returns (bytes memory) {
        return abi.encodeCall(MockV1.initialize, (owner, 1, 2, 3, 4));
    }

    function _setToken(address proxyAddress) internal override {
        mockV1 = MockV1(proxyAddress);
    }

    // ============ Tests ============= //

    function test_initialize_override() public view {
        assertEq(mockV1.a(), 2); // 1 * 2
        assertEq(mockV1.b(), 4); // 2 * 2
        assertEq(mockV1.c(), 6); // 3 * 2
        assertEq(mockV1.d(), 8); // 4 * 2
        assertEq(mockV1.e(), 20); // e = a + b + c + d
    }
}

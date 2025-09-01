# Upgradeable Smart Contracts

This project demonstrates how to create upgradeable smart contracts using Foundry's Forge and the OpenZeppelin Upgrades library. Upgradeable contracts allow you to modify contract logic while preserving the contract's state and address.

## Prerequisites

- [Foundry](https://getfoundry.sh/)
- [Solidity](https://docs.soliditylang.org/en/v0.8.0/installing-solidity.html)

## Setup

1. Clone the repository:

   ```sh
   git clone git@github.com:sscovil/upgradeable-smart-contracts.git
   ```

2. Navigate to the project directory:

   ```sh
   cd upgradeable-smart-contracts
   ```

3. Install the dependencies:

   ```sh
   forge install foundry-rs/forge-std
   forge install OpenZeppelin/openzeppelin-contracts-upgradeable
   forge install OpenZeppelin/openzeppelin-foundry-upgrades
   ```

## Run Tests

To run the tests, use the following command:

```sh
forge test --ffi
```

Use the `--force` flag to recompile the contracts before running the tests:

```sh
forge test --ffi --force
```

To specify a particular test file, use the `--match-path` option:

```sh
forge test --ffi --match-path test/YourTestFile.t.sol
```

To specify a particular test function, use the `--match-test` option:

```sh
forge test --ffi --match-test testFunctionName
```

## Generate Coverage Report

To generate a coverage report, use:

```sh
forge coverage --ffi
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Additional Resources

- [Intro to Smart Contracts](https://docs.soliditylang.org/en/v0.8.0/introduction-to-smart-contracts.html)
- [Solidity Docs](https://docs.soliditylang.org/en/v0.8.0/)
- [Forge Docs](https://getfoundry.sh/forge/overview)
- [Forge Tests](https://getfoundry.sh/forge/tests/overview)
- [OpenZeppelin Upgrades](https://docs.openzeppelin.com/contracts/5.x/upgradeable)
- [OpenZeppelin Foundry Upgrades](https://github.com/OpenZeppelin/openzeppelin-foundry-upgrades)

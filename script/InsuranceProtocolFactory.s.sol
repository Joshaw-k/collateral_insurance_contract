// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/InsuranceProtocolFactory.sol";

contract InsuranceProtocolFactoryScript is Script {
    InsuranceProtocolFactory _InsurancePoolFactory;
    address _admin = payable(0xB5119738BB5Fe8BE39aB592539EaA66F03A77174);
    address _user = payable(0xe26C94adb17e135a09478c5f41D21af338345DDD);
    address token = 0xD171C0e50a6ADcC7648a750b3D88C2273C87d295;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        _InsurancePoolFactory = new InsuranceProtocolFactory(token, _admin);
        _InsurancePoolFactory.createInsurancePool(0.001 ether);
        IERC20(token).transfer(
            address(_InsurancePoolFactory),
            (200 * 10 ** 18)
        );
        _InsurancePoolFactory.createCollateralPool{value: 0.001 ether}();
        vm.stopBroadcast();
    }
}

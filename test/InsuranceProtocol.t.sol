// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import {Test, console2, stdError} from "forge-std/Test.sol";
import {InsuranceProtocolFactory} from "../src/InsuranceProtocolFactory.sol";
import {InsuranceProtocol} from "../src/InsuranceProtocol.sol";
import {CollateralProtocol} from "../src/CollateralProtocol.sol";
import {LoanToken} from "../src/LoanToken.sol";

contract CounterTest is Test {
    InsuranceProtocolFactory public insuranceProtocolFactory;
    LoanToken public _LoanToken;

    InsuranceProtocol _insuredCrypto;
    CollateralProtocol _CollateralProtocol;

    address _insurer = address(0x11);
    address admin = address(0x22);

    function setUp() public {
        _LoanToken = new LoanToken();
        insuranceProtocolFactory = new InsuranceProtocolFactory(address(_LoanToken),admin);
        _LoanToken.mint(_insurer, 10000000000000000000000);
    }

    function test_InsuredCryto() public {
        uint96 protocolInsuredFee = 0.1 ether;
        vm.deal(_insurer, 1 ether);
        vm.startPrank(_insurer);
        insuranceProtocolFactory.createInsurancePool(protocolInsuredFee);
        _insuredCrypto = insuranceProtocolFactory.insurancePools(_insurer);
        _insuredCrypto.payMonthlyPremium{value: 0.1 ether}();
        vm.warp(32 days);
        _insuredCrypto.payMonthlyPremium{value: 0.1 ether}();
        assertEq(address(_insuredCrypto).balance, 0.2 ether);
        _insuredCrypto.claimInsurance(0.2 ether);
        vm.stopPrank();
    }

    function test_CollateralProtocol() public {
        vm.deal(_insurer, 1 ether);
        _LoanToken.mint(address(insuranceProtocolFactory), 10000000000000000000000);
        vm.startPrank(_insurer);
        insuranceProtocolFactory.createCollateralPool{
            value: 0.1 ether
        }();
        _CollateralProtocol = insuranceProtocolFactory.collateralPools(_insurer);
        _LoanToken.approve(address(_CollateralProtocol), 10000000000000000000000);
        _CollateralProtocol.repayLoan(100000000000000000000);
    }
}
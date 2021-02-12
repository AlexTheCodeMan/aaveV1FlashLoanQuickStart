pragma solidity ^0.6.6;

import "./aaveV1/FlashLoanReceiverBase.sol";
import "./aaveV1/ILendingPoolAddressesProvider.sol";
import "./aaveV1/ILendingPool.sol";

contract FLExampleV1 is FlashLoanReceiverBase {

    constructor() FlashLoanReceiverBase(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8) public {}

    /**
        This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external
        override
    {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");

        //
        // Your logic goes here.
        // !! Ensure that *this contract* has enough of `_reserve` funds to payback the `_fee` !!
        //

        uint totalDebt = _amount.add(_fee);
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

    /**
        Flash loan 1000000000000000000 wei (1 ether) worth of `_asset`
     */
    function flashloan(address _asset, uint amount) public onlyOwner {
        bytes memory data = "";

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), _asset, amount, data);
    }
}

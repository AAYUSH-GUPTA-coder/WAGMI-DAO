// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WagmiDAO is ERC20("WAGMI DAO", "WAGMI") {
    uint256 public constant EXCHANGE_RATE = 20;

    // Function: Buy $WAGMI (mint) token in exchange for $ETH
    function buy(uint256 _amount) public payable{
        require(msg.value >= _amount,"SEND SUFFICIENT ETH");
        // Step 1: Retrieve the amount of $eth deposited
        uint256 ETHamount = msg.value;
        // Step 2: Calculate the amount of $WAGMI token to mint
        // uint256 WAGMIamount = ETHamount / EXCHANGE_RATE; 
        uint256 WAGMIamount = ETHamount * EXCHANGE_RATE; 

        // Step 3: Mint $WAGMI to the caller address
        address sender = msg.sender;
        _mint(sender, WAGMIamount);
    }

    // function 2: Redeem $WAGMI (burn) and get $ETH back
    function redeem(uint256 _wagmiToRedeem) public {
        // step 1: Check that the user has enough $WAGMI balance
        require(balanceOf(msg.sender)  >= _wagmiToRedeem, "INSUFFICIENT BALANCE");

        // step 2: Calculate the amount of $ETH to get back from burning $WAGMI
        uint256 ETHamount = _wagmiToRedeem / EXCHANGE_RATE;

        require(address(this).balance >= ETHamount, "NOT ENOUGH ETH");

        // step 3: Burn the $WAGMI token
        _burn(msg.sender, _wagmiToRedeem);

        // step 4: Transfer $ETH to the user
        payable(msg.sender).transfer(ETHamount);
    }

    function decimals() public pure override returns(uint8){
        return 18;
    }
}
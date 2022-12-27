// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    function balanceOf(address account) external view returns (uint256);
}

contract Faucet {
    uint256 constant public tokenAmount = 100000000; // 100 EUROe
    uint256 constant public cooldown = 24 hours; // Must wait 24h between faucet calls per address

    ERC20 public tokenAddress;

    mapping(address => uint256) lastUse;

    constructor(address _tokenAddress) {
        tokenAddress = ERC20(_tokenAddress);
    }

    function getEUROe() public {
        require(withdrawalAllowed(msg.sender), "You can only withdraw from the contract every 24 hours");
        tokenAddress.transfer(msg.sender, tokenAmount);
        lastUse[msg.sender] = block.timestamp;
    }

    function getBalance() public view returns (uint256) {
        return ERC20(tokenAddress).balanceOf(address(this));
    }

    function withdrawalAllowed(address _address) public view returns (bool) {
        if (lastUse[_address] == 0) {
            return true;
        } 
        else if (block.timestamp >= lastUse[_address] + cooldown) {
            return true;
        }
        else {
            return false;
        }
        
    }

}
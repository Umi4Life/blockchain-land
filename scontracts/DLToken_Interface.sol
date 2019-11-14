pragma solidity ^0.5.0;

interface DLToken_Interface {
    function sendTokens(address fromAccount, uint256 fee, address toAccount) external payable returns(bool);
}
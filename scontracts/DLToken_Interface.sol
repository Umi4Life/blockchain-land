pragma solidity ^0.5.0;

interface DLToken_Interface {
    //will implement later
    function sendRequest() external payable returns (uint256); //RID
    function confirmRequest() external returns (bool);
    function rejectReject() external returns (bool);
    function checkContractBalance() external returns (uint256);
    //function deposit(uint256 sentEther) external returns (uint256);
        // function withdraw(uint256 storedEther) external returns (uint256);
} 
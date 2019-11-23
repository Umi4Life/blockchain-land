pragma solidity ^0.5.0;

interface DLToken_Interface {
     /**
     * @dev When the company wants to request for land, we need to build the structure of the request first.
     * Explaination of variables
     * RID - The request ID, which is unique and incrementing.
     * status - The indicator whether the request been process.
     * approval - The indicator whether the request has been approved.
     * companyAddress - The container of the company address that sent this request.
     * encryptedData - The request's encrypted data.
     * docHash - After the request has been approved, the request's dochash will be filled.
     */
    struct RequestForLand {
        uint64 RID;
        bool status;
        bool approval;
        address companyAddress;
        string encryptedData;
        string docHash;
    }
    /**
     * @dev When the company wants to request for land, we need to encrypt the data first and fill the docHash to be 'Unknown'.
     * This will return the RID of the request.
     */
    function sendRequest(string calldata encryptedData, string calldata docHash) external payable returns (uint64);
    /**
     * @dev When the company wants to check the requests for land, we can reveal the block sent to the blockchain by using RID.
     * This will return the request block of the specific RID.
     */
    function checkRequest(uint64 RID) external view returns (uint64, bool, bool, address, string memory, string memory);
    /**
     * @dev When the DL wants to set the hash of the approved request, RID and the hash is required.
     * This will return nothing, but the data in the memory will be changed.
     * This function needs a modifier to keep this function for the specific address like DL.
     */
    function setHash(uint64 RID, string calldata toSet) external;
    /**
     * @dev When the DL wants to approve request, RID is required.
     * This will return nothing, but the request will be shown approved and it cannot be changed.
     * This function needs a modifier to keep this function for the specific address like DL.
     */
    function acceptRequest(uint64 RID) external payable;
    /**
     * @dev When the DL wants to reject request, RID is required.
     * This will return nothing, but the request will be shown rejected and it cannot be changed.
     * This function needs a modifier to keep this function for the specific address like DL.
     */
    function rejectRequest(uint64 RID) external payable;
    /**
     * @dev Check the ether balance of the smart contract.
     */
    function checkContractBalance() external view returns (uint256);

    event RequestSent(address indexed from, address indexed to, uint256 value, uint64 RID);
    event DecisionOnRequest(uint64 RID, bool status, bool approval);

}
pragma solidity ^0.5.0;

import "./Context.sol";
import "./IERC20.sol";
import "./SafeMath.sol";
import "./DLToken_Interface.sol";

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20Mintable}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 *
 * Also, this contract implement {DLToken_Interface}.
 * This contract is a part of the ICCS487 projects.
 */
contract DLToken is Context, IERC20, DLToken_Interface {
    using SafeMath for uint256;
    using SafeMath for uint64; //Added this library for RID
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (uint64 => address) private _companyAddress;
    address private _minter;
    uint256 private _totalSupply;
    uint256 private _costWei; //fee for requesting
    uint256 private _costToken; //fee for requesting
    uint64 private _RIDglobal; //RID tracker
    address payable _LDaddress;
    modifier onlyLD() {
        require(isLD(), "Only Department of Land has permission to do this");
        _;
    }
    function isLD() public view returns(bool) {
        return _msgSender() == _minter;
    }
    RequestForLand[] public requests;
    /**
        @dev Read more in the DL_Interface
    */
    function acceptRequest(uint64 RID) public payable onlyLD {
        require(checkContractBalance() >= _costWei, "Not enough wei on this contract to pay back.");
        require(_getRequestStatus(RID) == false, "Request has been decided.");
        _setRequestStatus(RID, true);
        _setRequestApproval(RID, true);
        _transfer(address(this), _minter, _costToken); // transfer money from dapp to LD
        _LDaddress.transfer(_costWei);
        emit DecisionOnRequest(RID, _getRequestStatus(RID), _getRequestApproval(RID));
    }
    /**
        @dev Read more in the DL_Interface
    */
    function sendRequest(string memory encryptedData, string memory docHash) public payable returns (uint64){
        require(balanceOf(_msgSender()) >= _costToken, 'Not enough tokens in your account');
        require(msg.value == _costWei, 'The amount of wei is incorrect.');
        transfer(address(this), _costToken);
        _companyAddress[_RIDglobal] = _msgSender();
        requests.push(RequestForLand(_RIDglobal, false, false, _msgSender(), encryptedData, docHash));
        emit RequestSent(_msgSender(), _minter, _costToken,_RIDglobal);
        _RIDglobal += 1;
        return _RIDglobal-1;
    }
    /**
        @dev Read more in the DL_Interface
    */
    function rejectRequest(uint64 RID) public payable onlyLD {
        require(checkContractBalance() >= _costWei, "Not enough wei on this contract to pay back.");
        require(_getRequestStatus(RID) == false, "Request has been decided.");
        _setRequestStatus(RID, true);
        _setRequestApproval(RID, false);
        _transfer(address(this), requests[RID].companyAddress, _costToken);
        _LDaddress.transfer(_costWei);
        emit DecisionOnRequest(RID, _getRequestStatus(RID), _getRequestApproval(RID));
    }
    /**
        @dev Read more in the DL_Interface
    */
    function checkRequest(uint64 RID) public view returns (uint64, bool, bool, address, string memory, string memory){
        return (RID,  _getRequestStatus(RID), _getRequestApproval(RID), _getRequestAddress(RID),  _getRequestData(RID), _getRequestHash(RID));
    }
    /**
        @dev Read more in the DL_Interface
    */
    function setHash(uint64 RID, string memory toSet) public onlyLD {
        require(_getRequestApproval(RID) == true, "This request has not been approved.");
        _setHash(RID, toSet);
    }
    /**
        @dev Read more in the DL_Interface
    */
    function checkContractBalance() public view returns (uint256){
        return address(this).balance;
    }
    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }
    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * Parm : Well, we cannot allow anyone to send your tokens!
     * The one who calls this function has to be allowed to do this. There are 4 functions.
     * Approve - put in the address of your spender, that address can do anything with that amount of tokens, but not recieving it yet :D
     * IncreaseAllowance/DecreaseAllowance - put in the address of any spender, that address's allowance will be changed by that amount.
     * Allowance - READ-ONLY which used to check the amount of allowance owner of tokens allowed to the spender.
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(sender == _msgSender() || amount <= allowance(sender, _msgSender()), "Your transaction exceeds the sender's allowance");
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue));
        return true;
    }
    
    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal onlyLD {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal onlyLD {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount);
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount));
    }
    function _burnContract() private onlyLD{
        require(checkContractBalance() >= _costWei, "Not enough wei on this contract to burn.");
        address(0x0).transfer(_costWei); //proof of burn
    }
    function _getRequestHash(uint64 RID) private view returns (string memory){
        require(RID < _RIDglobal, "Your RID is incorrect.");
        return requests[RID].docHash;
    }

    function _getRequestApproval(uint64 RID) private view returns (bool){
        require(RID < _RIDglobal, "Your RID is incorrect.");
        return requests[RID].approval;
    }
    function _getRequestAddress(uint64 RID) private view returns (address){
        require(RID < _RIDglobal, "Your RID is incorrect.");
        return requests[RID].companyAddress;
    }
    function _getRequestStatus(uint64 RID) private view returns (bool){
        require(RID < _RIDglobal, "Your RID is incorrect.");
        return requests[RID].status;
    }
    function _getRequestData(uint64 RID) private view returns (string memory){
        require(RID < _RIDglobal, "Your RID is incorrect.");
        return requests[RID].encryptedData;
    }
    function _setRequestStatus(uint64 RID, bool toSet) private onlyLD {
        require(RID < _RIDglobal, "Your RID is incorrect.");
        requests[RID].status = toSet; //set request status
    }
    function _setRequestApproval(uint64 RID, bool decision) private onlyLD{
        require(RID < _RIDglobal, "Your RID is incorrect.");
        requests[RID].approval = decision;
    }
    function _setHash(uint64 RID, string memory setHash) private onlyLD {
        require(RID < _RIDglobal, "Your RID is incorrect.");
        requests[RID].docHash = setHash;
    }

    constructor () public{ //use when deploy
        _minter = _msgSender();
        _LDaddress = _msgSender();
        _costWei = 30000;
        _costToken = 100;
        _RIDglobal = 0;
        _mint(_minter, 1000000000000);
    }
}


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NestToken is ERC20, Ownable {
    uint256 public _totalSupply;
    address private payC;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    event SellToken(
        uint256 amountOfToken,
        uint256 amountOfEther,
        address senderAddress
    );

    // Constrctor function

    constructor() ERC20("NestToken", "NST") {
        _totalSupply = 1000000 * 10**18;
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function mint(address _to, uint256 _value) external onlyOwner {
        _mint(_to, _value);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address tokenOwner)
        public
        view
        override
        returns (uint256 balance)
    {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender)
        public
        view
        override
        returns (uint256 remaining)
    {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint256 tokens)
        public
        override
        returns (bool success)
    {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transfer(address to, uint256 tokens)
        public
        override
        returns (bool success)
    {
        balances[msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokens
    ) public override returns (bool success) {
        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(from, to, tokens);
        return true;
    }

    function setPaymentContract(address addr) public onlyOwner returns (bool) {
        payC = addr;
        return true;
    }

    function getPaymentContract() public view onlyOwner returns (address) {
        return payC;
    }

    function sellTokens(uint256 amount) public {
        uint256 ethPerTokens = 10000;

        uint256 totalEther = amount / ethPerTokens;

        transfer(payC, amount);

        (bool success, ) = msg.sender.call{value: totalEther}("");

        require(success == true, "Payment failed");

        emit SellToken(amount, totalEther, msg.sender);
    }
}

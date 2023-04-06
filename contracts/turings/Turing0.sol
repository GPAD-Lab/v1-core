pragma solidity ^0.8.17;

import "../interfaces/ITuring.sol";
import "../GETH.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Turing0 is ITuring, ERC20 {
    GETH public geth;

    constructor(
        GETH _geth,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {
        geth = _geth;
    }

    function burnFrom(address _from, uint256 _amount) external override {
        geth.burnFrom(_from, _amount);
        _mint(_from, _amount);
    }
}

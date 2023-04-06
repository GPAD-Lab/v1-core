pragma solidity ^0.8.17;

import "../interfaces/ITuring.sol";
import "../GETH.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Turing1 is ITuring, ERC721 {
    GETH public geth;

    constructor(
        GETH _geth,
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        geth = _geth;
    }

    function burnFrom(address _from, uint256 _amount) external override {
        geth.burnFrom(_from, _amount);
        uint256 basePrice = 1 ether;
        if (_amount >= basePrice) {
            _mint(_from, _amount / basePrice);
        }
    }
}

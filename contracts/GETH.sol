pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GETH is ERC20Burnable {
    address public immutable factory;

    using Strings for uint256;

    modifier onlyFactory() {
        require(factory == msg.sender, "Caller is not the factory");
        _;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return "gETH";
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return "gETH";
    }

    constructor() ERC20("", "") {
        factory = msg.sender;
    }

    function mint(address _account, uint256 _amount) external onlyFactory {
        _mint(_account, _amount);
    }
}

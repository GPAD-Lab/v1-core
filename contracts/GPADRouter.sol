pragma solidity ^0.8.17;

import "./interfaces/IGPADRouter.sol";
import "./interfaces/ITuring.sol";
import "./GETH.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract GPADRouter is IGPADRouter {
    struct GPADFund {
        GETH gETH;
        address creator;
        uint256 amount;
        ITuring turing;
    }

    GPAD[] public gpads;

    address public implement;

    mapping(uint256 => GPADFund) public gpadFunds;

    modifier onlyCreator(uint256 _id) {
        require(gpadFunds[_id].creator == msg.sender, "You are not creator");
        _;
    }

    event CreateGPAD(
        uint indexed _id,
        address indexed _creator,
        GPAD _gpad,
        GETH _geth
    );

    event Invest(
        uint256 indexed _id,
        uint256 _amount,
        address indexed _investor
    );

    constructor() {
        implement = address(new GETH());
    }

    function createGPAD(GPAD calldata _gpad) external override {
        gpads.push(_gpad);
        GETH gETH = GETH(Clones.clone(implement));
        uint256 id = gpads.length - 1;
        gpadFunds[id].gETH = gETH;
        gpadFunds[id].creator = msg.sender;
        emit CreateGPAD(id, msg.sender, _gpad, gETH);
    }

    function setTuring(uint256 _id, ITuring _turing) external onlyCreator(_id) {
        gpadFunds[_id].turing = _turing;
    }

    function invest(uint256 _id) external payable override {
        require(
            address(gpadFunds[_id].gETH) != address(0),
            "This id has not been deployed yet"
        );
        require(
            block.timestamp >= gpads[_id].startTime &&
                block.timestamp <= gpads[_id].endTime,
            "This id has not been opened"
        );

        uint256 amount = msg.value;
        require(
            gpadFunds[_id].amount + amount <= gpads[_id].maxETHTVL,
            "This id has been max"
        );
        gpadFunds[_id].amount += amount;
        gpadFunds[_id].gETH.mint(msg.sender, amount);
        payable(gpadFunds[_id].creator).transfer(amount);
        emit Invest(_id, amount, msg.sender);
    }
}

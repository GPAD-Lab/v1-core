pragma solidity ^0.8.17;

interface IGPADRouter {
    struct GPAD {
        string name;
        string description;
        uint256 startTime;
        uint256 endTime;
        uint256 maxETHTVL;
    }

    function createGPAD(GPAD calldata _gpad) external;

    function invest(uint256 _id) external payable;

}

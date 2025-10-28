// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Land Record Management
 * @dev A simple smart contract for registering and transferring land ownership.
 */
contract LandRecordManagement {

    struct Land {
        uint256 id;
        string location;
        uint256 area;
        address currentOwner;
    }

    mapping(uint256 => Land) public lands;
    uint256 public landCount;
    address public admin;

    event LandRegistered(uint256 landId, string location, uint256 area, address owner);
    event LandTransferred(uint256 landId, address from, address to);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyOwner(uint256 _landId) {
        require(lands[_landId].currentOwner == msg.sender, "Only land owner can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @dev Register a new land record.
     * @param _location The physical location or description of the land.
     * @param _area The size of the land in square meters.
     * @param _owner The address of the initial owner.
     */
    function registerLand(string memory _location, uint256 _area, address _owner) public onlyAdmin {
        landCount++;
        lands[landCount] = Land(landCount, _location, _area, _owner);
        emit LandRegistered(landCount, _location, _area, _owner);
    }

    /**
     * @dev Transfer ownership of a land.
     * @param _landId The ID of the land to transfer.
     * @param _newOwner The address of the new owner.
     */
    function transferLand(uint256 _landId, address _newOwner) public onlyOwner(_landId) {
        address previousOwner = lands[_landId].currentOwner;
        lands[_landId].currentOwner = _newOwner;
        emit LandTransferred(_landId, previousOwner, _newOwner);
    }

    /**
     * @dev Retrieve land details by ID.
     * @param _landId The ID of the land.
     * @return Land struct details.
     */
    function getLandDetails(uint256 _landId) public view returns (Land memory) {
        return lands[_landId];
    }
}

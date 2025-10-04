// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Crowdfund {
    address public owner;
    uint256 public goal;
    uint256 public deadline;
    uint256 public raised;
    bool public finalized;
    enum Outcome {Ongoing,Successful,Failed }
    Outcome public outcome;
    mapping(address => uint256) public donations;

    event Donated(address indexed Donor, uint256 amount);
    event Finalized(Outcome outcome, uint256 raised);
    event Withdrawn(address indexed to, uint256 amount);
    event RefundOfFailedGoal(address indexed claimer, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor(uint256 _goal, uint256 _durationSeconds) {
        require(_goal > 0, "goal>0");
        require(_durationSeconds > 0, "duration>0");
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _durationSeconds;
        outcome = Outcome.Ongoing;
    }

    function donate() external payable {
        require(block.timestamp < deadline, "deadline passed");
        require(msg.value > 0, "value>0");

        donations[msg.sender] += msg.value;
        raised += msg.value;

        emit Donated(msg.sender, msg.value);
    }

    function finalize() external {
        require(block.timestamp >= deadline, "too early");
        require(!finalized, "already finalized");

        if (raised >= goal) {
            outcome = Outcome.Successful;
        } else {
            outcome = Outcome.Failed;
        }
        finalized = true;
        emit Finalized(outcome, raised);
    }

    function withdraw() external onlyOwner {
        require(finalized, "not finalized");
        require(outcome == Outcome.Successful, "not successful");
        uint256 amount = raised;
        raised = 0;
        (bool ok, ) = owner.call{value: amount}("");
        require(ok, "withdraw failed");
        emit Withdrawn(owner, amount);
    }

    function refundOfFailedGoal() external {
        require(finalized, "not finalized");
        require(outcome == Outcome.Failed, "not failed");
        uint256 donation = donations[msg.sender];
        require(donation > 0, "no donation");
        donations[msg.sender] = 0;
        (bool ok, ) = msg.sender.call{value: donation}("");
        require(ok, "refund failed");
        emit RefundOfFailedGoal(msg.sender, donation);
    }
}
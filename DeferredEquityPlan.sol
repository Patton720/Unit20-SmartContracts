pragma solidity ^0.5.0;
contract DeferredEquityPlan {
    address human_resources;
    address payable employee; //bob
    bool active = true; //this employee is active at the start of the contract.
    //Set the total shares and annual distribution
    uint public distributed_shares;
    uint public total_shares = 1000;
    uint public annual_distribution = 250;
    //Set the unlock_time to be 365 days from now.
    uint public start_time = now;
    uint public unlock_time;
    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }
    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized on this contract.");
        require(active == true, "Contract not active.");
        //Add require unlock time less than or equal to now
        require(unlock_time <= start_time, "You need to wait one year");
        //Add require distributed shares is less than total shares
        require(address(this).balance < total_shares, "You don't have enough shares.");
        //Add 365 days to unlock time
        unlock_time = now + 365 days;
        /*
        Calculate the shares distributed by using the function:
            (now-start_time)/365 * annual distribution
        Double check in case the employee doesnt cash out until after 5+ years
            if (distributed_shares>1000) {
                distributed_shares=1000;
            }
        */
        distributed_shares = (now-start_time)/365 * annual_distribution;
        if (distributed_shares>total_shares) {
            distributed_shares=total_shares;
        }
    }
        //hr and employee can deactivate contract at will
    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }
    function () external payable {
        revert("Don't Send Ether to this contract");
    }
}
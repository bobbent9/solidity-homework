pragma solidity >=0.5.0;

contract DeferredEquityPlan {
    address employer;

    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract

    unit total_shares = 1000;
    unit annual_distribution = 250; 

    unit start_time = now; // permanently store the time this contract was initialized

    unit unlock_time = now + 365 days;

    unit public distributed_shares; // starts at 0

    constructor(address payable _employee) public {
        employer = msg.sender;
        employee = _employee;
    }

    function distribute() public {
        require(msg.sender == employer || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract not active.");

        require(unlock_time <= now, "Not all shares have been vested.");
        require(distributed_shares < total_shares, "All shares have been distributed.");

        unlock_time += 365 days; 
        distributed_shares = (now - start_time) / 365 days * annual_distribution;
   
        if (distributed_shares > 1000) {
            distributed_shares = 1000;
        }
    }

pragma solidity ^0.4.22;


contract IceChain {
    
    // Constants
    uint NOT_RUNNING = 0;
    uint RUNNING = 1;
    uint FAILED = 2;
    uint COMPLETED = 3;
    
    // Modifiers
    modifier isAdmin() {
        require(msg.sender == owner);
        _;
    }
    
    modifier limitedPayable() {
        require(refunds[depositor] <= depositLimit);
        _;
    }
    
    modifier isDepositable() {
        require(status == NOT_RUNNING);
        require(msg.sender == depositor);
        _;
    }
    
    modifier isRunning() {
        require(status == RUNNING);
        _;
    }
    
    modifier isWithdrawable() {
        require(status == FAILED || status == NOT_RUNNING || status == COMPLETED);
        _;
    }
    
    modifier stopInEmergency { if (!stopped) _; }
    modifier onlyInEmergency { if (stopped) _; }
    
    // Circuit Breaker
    bool private stopped = false;
    address private owner;
    
    // Contract initialized values
    address depositor; 
    address otherParty;
    uint256 depositLimit;
    uint256 deposited = 0;
    int maxTemperature;
    int minTemperature;
    uint deadlineDate;
    string description;
    uint private status = NOT_RUNNING;
  
    // Holds how much QTUM each address can pull out as a refund
    mapping(address => uint) refunds;
  
    constructor(address _depositor, address _otherParty, uint256 _depositLimit, int _minTemperature, int _maxTemperature, uint _deadlineDate, string _description) public {
        // Check parameters are valid
        require(address(_depositor) != 0x0);
        require(address(_otherParty) != 0x0);
        require(_minTemperature > -1000);
        require(_maxTemperature < 1000);
        require(_maxTemperature > _minTemperature);
        require(_deadlineDate > now);
        require(bytes(_description).length > 0);
        
        // Set Contract values
        depositor = _depositor;
        otherParty = _otherParty;
        minTemperature = _minTemperature;
        maxTemperature = _maxTemperature;
        deadlineDate = _deadlineDate;
        description = _description;
        depositLimit = _depositLimit;
        
        // save the contract deployer as admin
        owner = msg.sender;
    }
    
    function checkTemperaturesAndDate(int[] temperatures) public isRunning returns (bool) {
        if (now > deadlineDate) {
            contractFailed();
            return false;
        }
        
        for (uint i=0; i< temperatures.length; i++) {
            int temp = temperatures[i];
            if (temp > maxTemperature || temp < minTemperature) {
                contractFailed();
                return false;
            }
        }
        
        contractSucceed();
        return true;
    }
    
    // Status Changing functions
    function contractFailed() internal {
        status = FAILED;
        
        // The funds are now available for the other party to take
        refunds[otherParty] = refunds[depositor];
        refunds[depositor] = 0;
    }
    
    function contractSucceed() internal {
        status = COMPLETED;
    }
    
    // Fund transfer functions
    function deposit() external payable limitedPayable isDepositable {
        refunds[msg.sender] = msg.value;
        if (refunds[depositor] == depositLimit) {
            status = RUNNING;
        }
    }
    
    function withdrawRefund() external isWithdrawable {
        uint refund = refunds[msg.sender];
        msg.sender.transfer(refund);
        refunds[msg.sender] = 0;
        
        if (status != COMPLETED && refunds[depositor] < depositLimit) {
            status = FAILED;
        }
    }
    
    // Circuit Breaker function
    function toggleContractActive() external isAdmin {
        // Can add additional modifier that restricts stopping a contract to be based on another action.
        stopped = !stopped;
    }
    
    // External functions to check internal values
    function getStatus() external view returns (uint) {
        return status;
    }
    
    function getDepositor() external view returns (address) {
        return depositor;
    }
    
    function getOwner() external view returns (address) {
        return owner;
    }
    
    function getStopped() external view returns (bool) {
        return stopped;
    }
    
    function refundableAmount() external view returns (uint256) {
        return refunds[msg.sender];
    }
    
    function getDepositedAmount() external view returns (uint256) {
        return refunds[depositor];
    }
    
    function getDepositLimit() external view returns (uint256) {
        return depositLimit;
    }
}

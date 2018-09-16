pragma solidity ^0.4.18;

contract Shipment {

  address public owner;

  uint public receivedFunds;
  uint public returnedFunds;

  struct Owner {
    address addr;
    bool isSeller;
    bool init;
  }
  
  uint[] temps;

  struct Order {
    string cargoType;
    uint maxTemp;
    uint minTemp;
    uint deposit;
    address depositor;
    uint depositRate;
    string status;
    bool init;
  }
  
  Order order;

  /// The smart contract's constructor
  constructor() public  {
    /// The seller is the contract's owner
    owner = msg.sender;
  }

  function createOrder(string cargoType, uint maxTemp, uint minTemp, uint deposit, address depositor, uint depositRate) 
    payable public 
    returns(bool)
    {
      
    // Ensure that the person receiving the contract is the one to create the order (accepting)
    require(msg.sender != owner);
    order = Order(cargoType, maxTemp, minTemp, deposit, depositor, depositRate, "running", true);
  }
  
  event LogReceivedFunds(address sender, uint amount);
  event LogReturnedFunds(address recipient, uint amount);
  
  function deposit() 
    payable public 
    returns(bool success)
    {
        receivedFunds += msg.value;
        emit LogReceivedFunds(msg.sender, msg.value);
        return true;
    }
    
    function sendTempArray(uint[] tempArray) public {
        temps = tempArray;
    }
    
    function completeShipment(uint amountToWithdraw) 
        public
        returns(bool success)
    {
        // owed = moneyReceived - moneyAlreadyReturned;
        uint netOwed = receivedFunds - returnedFunds;
    
        // cannot ask for more than is owed
        assert(amountToWithdraw < netOwed);
    
        returnedFunds += amountToWithdraw;
        emit LogReturnedFunds(msg.sender, amountToWithdraw);
        assert(msg.sender.send(amountToWithdraw));
        return true;
    }    
}

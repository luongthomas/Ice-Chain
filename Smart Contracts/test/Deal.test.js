var Deal  = artifacts.require("Deal");
var utils = require("../utils.js");

contract("Deal", function(accounts) {
 
  // Constant values
  const ORDER_PRICE            = 3;
  const ORDER_SAFEPAY          = 4;
  const ORDER_SHIPMENT_PRICE   = 5;
  const ORDER_SHIPMENT_SAFEPAY = 6;

  const INVOICE_ORDERNO = 1;
  const INVOICE_COURIER = 3;

  const TYPE_ORDER    = 1;
  const TYPE_SHIPMENT = 2;

  // Define variables that will be set during run time
  var seller         = null;
  var buyer          = null;
  var courier        = null;
  var orderno        = null;
  var invoiceno      = null;
  var order_price    = null;
  var shipment_price = null;
  var price          = null;
  var goods          = null;
  var quantity       = null;

  // Before each test is ran we are setting some variables
  before(function() {
    // Given an array of sample wallets/addresses and we are using some here
    seller         = accounts[0];
    buyer          = accounts[1];
    courier        = accounts[2];

    // Index of order and invoices
    orderno        = 1;
    invoiceno      = 1;

    // Setting prices
    order_price    = 100000;
    shipment_price = 50000;
    price          = order_price + shipment_price;

    // Type of goods and amount
    goods          = "Banana";
    quantity       = 200;
  });



  // Test 1: 
  it("The seller account should own the contract", function() {
    
    // Create empty deal variable
    var deal;

    // Create new Deal instance and set it to the deal variable
    // The `{from: sender}` defines who is creating this object
    //    (aka which addr is interacting with the contract)
    return Deal.new(buyer, {from: seller}).then(function(instance) {
      
      // Save created instance as deal variable and return the owner address
      deal = instance;
      return deal.owner();

    }).then(function(owner) {

      // Make sure that `seller` address is same address as 
      //    the address that created the contract
      assert.equal(seller, owner, "The seller account did not owns the contract");
    });
    
  });


  // Test 2: 
  it("The second account should be the buyer", function() {

    var deal;

    return Deal.new(buyer, {from: seller}).then(function(instance) {
      
      // Return the buyer address (address that the Deal 
      //    contract was initialized with)
      deal = instance;
      return deal.buyerAddr();

    }).then(function(buyer) {

      // Verify buyer address is same as the address we set it to in `before()`
      assert.equal(accounts[1], buyer, "The second account was not the buyer");
    });

  });


  // Test 3:
  it("The first order created is the first order on the list", function() {

    // The seller creates a Deal object
    var deal;
    return Deal.new(buyer, {from: seller}).then(function(instance) {
      
      // The buyer calls the send order on the contract
      deal = instance;
      return deal.sendOrder(goods, quantity, {from: buyer});

      // Sending an order (payable) results in a transaction object
    }).then(function(transaction) {

      // Promises are async
      return new Promise(function(resolve, reject) {

        // use web3 api to get the transaction information using the tx id
        //    from sendOrder
        return web3.eth.getTransaction(transaction.tx, function(err, tx) {
          if (err) { reject(err); } 
          else { resolve(tx); }
        });
      });
    }).then(function(tx) {
      console.log(tx.gasPrice.toString());

    }).then(function() {
      //query getTransactionReceipt
    }).then(function() {

      // Getting the first order in the list
      return deal.queryOrder(orderno);
    }).then(function(order) {

      // Ensures the order exists
      assert.notEqual(order, null, "The order number 1 did not exists"); 
    });

  });



  // TEST 4:
  it("The shipment price was set for an order", function() {

    var deal;
    return Deal.new(buyer, {from: seller}).then(function(instance) {
      deal = instance;

      // Send the order from the buyer
      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function() {

      // Send the price for the order
      return deal.sendPrice(orderno, shipment_price, TYPE_SHIPMENT, {from: seller});

    }).then(function() {

      // Get the order
      return deal.queryOrder(orderno); 
    }).then(function(order) {

      // make sure the order's shipment price matches the one we sent
      assert.equal(order[ORDER_SHIPMENT_PRICE].toString(), shipment_price); 
    });

  });
  

  // TEST 5:
  it("The order's price was set for an order", function() {

    var deal;
    return Deal.new(buyer, {from: seller}).then(function(instance) {
      deal = instance;

      // Send the order
      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function() {

      // Send the price
      return deal.sendPrice(orderno, order_price, TYPE_ORDER, {from: seller});
    }).then(function() {

      // Get the order
      return deal.queryOrder(orderno);
    }).then(function(order) {

      // Ensure the order price matches the one we sent
      assert.equal(order[ORDER_PRICE].toString(), order_price);
    });
  
  });


  // TEST 6:
  it("The safe pay amount is correct for an order", function() {
    
    var deal;
    return Deal.new(buyer, {from: seller}).then(function(instance) {
      deal = instance;
      
      // Send the order from buyer
      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function() {

      // Send the price of the order
      return deal.sendPrice(orderno, order_price, TYPE_ORDER, {from: seller});
    }).then(function() {

      // Send the price of the shipment
      return deal.sendPrice(orderno, shipment_price, TYPE_SHIPMENT, {from: seller});
    }).then(function() {

      // Send the payment based on the price from buyer
      return deal.sendSafepay(orderno, {from: buyer, value: price});
    }).then(function() {

      // Get the order
      return deal.queryOrder(orderno);
    }).then(function(order) {

      // Ensure the order's safepay amount (shipment price plus order price) matches price of order
      assert.equal(order[ORDER_SAFEPAY].toString(), price);
    });
  });


  // TEST 7:
  it("The contract's balance is correct after buyer pays", function() {
    
    var deal;
    return Deal.new(buyer, {from: seller}).then(function(instance) {
      deal = instance;
      
      // Send order from buyer
      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function() {

      // Send price for order
      return deal.sendPrice(orderno, order_price, TYPE_ORDER, {from: seller});
    }).then(function() {

      // Send price for shipment 
      return deal.sendPrice(orderno, shipment_price, TYPE_SHIPMENT, {from: seller});
    }).then(function() {

      // Send payment
      return deal.sendSafepay(orderno, {from: buyer, value: price});
    }).then(function() {
      return new Promise(function(resolve, reject) {

        // Get the balance of the contract address
        return web3.eth.getBalance(deal.address, function(err, hash) {
          if(err) {
            reject(err);
          }
          resolve(hash);
        });
      });
    }).then(function(balance) {

      // Verify the contract balance is the same as the price
      assert.equal(balance.toString(), price);
    });
  });


  // TEST 8:
  it("The first invoice is the first in the list after sending one invoice ", function() {
    
    var deal;

    return Deal.new(buyer, {from: seller}).then(function(instance) {
      deal = instance;

      // Send order from buyer
      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function() {

      // Send order price
      return deal.sendPrice(orderno, price, TYPE_ORDER, {from: seller});
    }).then(function() {

      // Send an Invoice with delivery date 
      return deal.sendInvoice(orderno, 0, courier, {from: seller});
    }).then(function() {

      // Get the invoice
      return deal.getInvoice(invoiceno);
    }).then(function(invoice) {

      // Ensure that the invoice exists
      assert.notEqual(invoice, null);
    });
  });
  

  // TEST 9:
  it("The first invoice is for the first order", function() {
    
    var deal;
    return Deal.new(buyer, {from: seller}).then(function(instance) {
      deal = instance;

      // Send an order from buyer
      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function() {

      // Send a price for the order
      return deal.sendPrice(orderno, price, TYPE_ORDER, {from: seller});
    }).then(function() {

      // Send an invoice for the order
      return deal.sendInvoice(orderno, 0, courier, {from: seller});
    }).then(function() {

      // Get the first invoice
      return deal.getInvoice(invoiceno);
    }).then(function(invoice) {

      // Verify the first invoice's order number is the same as the order number we requested the price for
      assert.equal(invoice[INVOICE_ORDERNO].toString(), orderno);
    });
  });


  // TEST 10:
  it("The courier was correct", function() {
    
    var deal;
    return Deal.new(buyer, {from: seller}).then(function(instance) {
      deal = instance;

      // Send an order
      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function() {

      // Send a price for the order
      return deal.sendPrice(orderno, price, TYPE_ORDER, {from: seller});
    }).then(function() {

      // Send an invoice for the order
      return deal.sendInvoice(orderno, 0, courier, {from: seller});
    }).then(function() {

      // Get an invoice for the order
      return deal.getInvoice(invoiceno);
    }).then(function(invoice) {

      // Ensure the invoice's courier is the same as the one sent in the invoice
      assert.equal(invoice[INVOICE_COURIER].toString(), courier);
    });
  });

  it("The contract's balance is correct after delivery", function() {
    
    var deal;
    return Deal.new(buyer, {from: seller}).then(function(instance) {
      deal = instance;

      // Send an order
      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function() {

      // Send an order price for the order
      return deal.sendPrice(orderno, order_price, TYPE_ORDER, {from: seller});
    }).then(function() {

      // Send a shipment price for the order
      return deal.sendPrice(orderno, shipment_price, TYPE_SHIPMENT, {from: seller});
    }).then(function() {

      // Send a payment to the contract
      return deal.sendSafepay(orderno, {from: buyer, value: price});
    }).then(function() {

      // Send an invoice
      return deal.sendInvoice(orderno, 0, courier, {from: seller});
    }).then(function() {

      // Mark an order as delivered
      return deal.delivery(invoiceno, 0, {from: courier});
    }).then(function() {
      return new Promise(function(resolve, reject) {

        // Get balance of contract address
        return web3.eth.getBalance(deal.address, function(err, hash) {
          if(err) {
            reject(err);
          }
          resolve(hash);
        });
      });
    }).then(function(balance) {

      // Ensure that the contract balance is zero, because the payment is sent from contract to courier and seller
      assert.equal(balance.toString(), 0);
    });
  });

});

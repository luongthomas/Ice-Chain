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

    }).then(function(owner){

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
  it("should first order was number 1", function() {

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
    }).then(function(tx){
      console.log(tx.gasPrice.toString());
    }).then(function(){
      //query getTransactionReceipt
    }).then(function(){
      return deal.queryOrder(orderno);
    }).then(function(order){
      assert.notEqual(order, null, "The order number 1 did not exists"); 
    });

  });

  it("should the shipment price was set", function(){

    var deal;

    return Deal.new(buyer, {from: seller}).then(function(instance){
      deal = instance;

      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function(){
      return deal.sendPrice(orderno, shipment_price, TYPE_SHIPMENT, {from: seller});
    }).then(function(){
      return deal.queryOrder(orderno); 
    }).then(function(order){
      assert.equal(order[ORDER_SHIPMENT_PRICE].toString(), shipment_price); 
    });

  });
  
  it("should the order's price was set", function(){

    var deal;

    return Deal.new(buyer, {from: seller}).then(function(instance){
      deal = instance;

      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function(){
      return deal.sendPrice(orderno, order_price, TYPE_ORDER, {from: seller});
    }).then(function(){
      return deal.queryOrder(orderno);
    }).then(function(order){
      assert.equal(order[ORDER_PRICE].toString(), order_price);
    });
  
  });

  it("should the safe pay was correct", function(){
    
    var deal;

    return Deal.new(buyer, {from: seller}).then(function(instance){
      deal = instance;
      
      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function(){
      return deal.sendPrice(orderno, order_price, TYPE_ORDER, {from: seller});
    }).then(function(){
      return deal.sendPrice(orderno, shipment_price, TYPE_SHIPMENT, {from: seller});
    }).then(function(){
      return deal.sendSafepay(orderno, {from: buyer, value: price});
    }).then(function(){
      return deal.queryOrder(orderno);
    }).then(function(order){
      assert.equal(order[ORDER_SAFEPAY].toString(), price);
    });
  });

  it("should the contract's balance was correct after the safepay", function(){
    
    var deal;

    return Deal.new(buyer, {from: seller}).then(function(instance){
      deal = instance;
      
      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function(){
      return deal.sendPrice(orderno, order_price, TYPE_ORDER, {from: seller});
    }).then(function(){
      return deal.sendPrice(orderno, shipment_price, TYPE_SHIPMENT, {from: seller});
    }).then(function(){
      return deal.sendSafepay(orderno, {from: buyer, value: price});
    }).then(function(){
      return new Promise(function(resolve, reject){
        return web3.eth.getBalance(deal.address, function(err, hash){
          if(err){
            reject(err);
          }
          resolve(hash);
        });
      });
    }).then(function(balance){
      assert.equal(balance.toString(), price);
    });
  });

  it("should the first invoice was number 1", function(){
    
    var deal;

    return Deal.new(buyer, {from: seller}).then(function(instance){
      deal = instance;

      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function(){
      return deal.sendPrice(orderno, price, TYPE_ORDER, {from: seller});
    }).then(function(){
      return deal.sendInvoice(orderno, 0, courier, {from: seller});
    }).then(function(){
      return deal.getInvoice(invoiceno);
    }).then(function(invoice){
      assert.notEqual(invoice, null);
    });
  });
  

  it("should the invoice 1 it is for order 1", function(){
    
    var deal;

    return Deal.new(buyer, {from: seller}).then(function(instance){
      deal = instance;

      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function(){
      return deal.sendPrice(orderno, price, TYPE_ORDER, {from: seller});
    }).then(function(){
      return deal.sendInvoice(orderno, 0, courier, {from: seller});
    }).then(function(){
      return deal.getInvoice(invoiceno);
    }).then(function(invoice){
      assert.equal(invoice[INVOICE_ORDERNO].toString(), orderno);
    });
  });

  it("should the courier was correct", function(){
    
    var deal;

    return Deal.new(buyer, {from: seller}).then(function(instance){
      deal = instance;

      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function(){
      return deal.sendPrice(orderno, price, TYPE_ORDER, {from: seller});
    }).then(function(){
      return deal.sendInvoice(orderno, 0, courier, {from: seller});
    }).then(function(){
      return deal.getInvoice(invoiceno);
    }).then(function(invoice){
      assert.equal(invoice[INVOICE_COURIER].toString(), courier);
    });
  });

  it("should the contract's balance was correct after the delivery", function(){
    
    var deal;

    return Deal.new(buyer, {from: seller}).then(function(instance){
      deal = instance;
      
      return deal.sendOrder(goods, quantity, {from: buyer});
    }).then(function(){
      return deal.sendPrice(orderno, order_price, TYPE_ORDER, {from: seller});
    }).then(function(){
      return deal.sendPrice(orderno, shipment_price, TYPE_SHIPMENT, {from: seller});
    }).then(function(){
      return deal.sendSafepay(orderno, {from: buyer, value: price});
    }).then(function(){
      return deal.sendInvoice(orderno, 0, courier, {from: seller});
    }).then(function(){
      return deal.delivery(invoiceno, 0, {from: courier});
    }).then(function(){
      return new Promise(function(resolve, reject){
        return web3.eth.getBalance(deal.address, function(err, hash){
          if(err){
            reject(err);
          }
          resolve(hash);
        });
      });
    }).then(function(balance){
      assert.equal(balance.toString(), 0);
    });
  });

});

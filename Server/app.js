var express = require("express");
var app = express();
var qtum = require("qtumjs-wallet");

var MongoClient = require('mongodb').MongoClient;
var url = 'mongodb://localhost:27017/ContractDB';


var sellerWIF = "cVUBPoxVEJan7bUSbwvsJeqFm6QkjDVuwxTuahL4YpSasggCimej"
var sellerAddr = "qfh6e3XVs7TKGHshf4ifLKh4uwSdLqrY1S"
var buyerWIF = "cPk2yVbgH7ZbUhCaffKQUKzaw8CNspXW3byhAsNG7eicZ9qry9Gk"
var buyerAddr = "qYnuZGG5z3zUfK71n5LMyvCJwjdqcpn5wy"
var BUYER = "BUYER"
var SELLER = "SELLER"

app.get("/balance/:accountType", (req, res, next) => {
    var accountType = String(req.params.accountType).trim().toUpperCase();

    getBalance(accountType, function(accountBalance) {
    	res.setHeader('Content-Type', 'application/json')
    	res.send(JSON.stringify({ accountType: accountBalance}))
    }).catch((err) => console.log(err))
});

app.get("/database", (req, res, next) => {
	MongoClient.connect(url, { useNewUrlParser: true }, function(err, database) {
		if (err) throw err;

		var db = database.db()
		// db.createCollection("Contracts", {autoIndexId: true}, function(err, res) {
		//     if (err) throw err;
		//     console.log("Collection created!");
		//     database.close();
		// });

		var cursor = db.collection('Contracts').find().toArray(function(err, items) {
			res.send(JSON.stringify({ "Entries": items}))
		})
	})
})


app.get("/database-insert", (req, res, next) => {
	MongoClient.connect(url, { useNewUrlParser: true }, function(err, database) {
		if (err) throw err;
		console.log("Connected");

		var db = database.db()
//		db.collection('Contracts').deleteOne({_id: 9})
		var wrappedBuyerAddr =  "\"" + buyerAddr + "\""
		var wrappedSellerAddr = "\"" + sellerAddr + "\""

		var cursor = db.collection('Contracts').insertOne({
			"_id": 9,
			"contractName": "Lotion Shipment",
			"description": "Lotion",
			"depositorName": "Buyer",
			"depositorEmail": "Buyer@gmail.com",
			"depositorAddress":  wrappedBuyerAddr,
			"otherPartyName": "Seller",
			"otherPartyAddress":  wrappedSellerAddr,
			"otherPartyEmail": "Seller@gmail.com",
			"minTemperature": 0,
			"maxTemperature": 100,
			"deadline": 1540773606,
			"depositLimit": 1,
			"status": 0,
			"cargoValue": 10
		})

		db.collection('Contracts').find({_id: 9}).toArray(function(err, items) {
			res.send(JSON.stringify({items}))
		})
	})
})

app.listen(5124, () => {
	// main()
	// walletInfo().catch((err) => console.log(err))
 	console.log("Server running on port 5124");
});


async function main() {
	const network = qtum.networks.testnet
	const mnemonic = qtum.generateMnemonic()
	const password = "covfefe"

	const wallet = network.fromMnemonic(mnemonic, password)
	console.log("mnemonic:", mnemonic)
	console.log("public address:", wallet.address)
	console.log("private key (WIF):", wallet.toWIF())
}

async function walletInfo() {
	const network = qtum.networks.testnet

	const privKey = "cVUBPoxVEJan7bUSbwvsJeqFm6QkjDVuwxTuahL4YpSasggCimej"
	const wallet = network.fromWIF(privKey)
	const info = await wallet.getInfo()
	console.log("public address: ", wallet.address)
	console.log("Wallet balance: ", wallet.balance)
	console.log("Wallet info: ", info)
}

async function getBalance(accountType, fn) {
	const network = qtum.networks.testnet
	var privKey = ""
	if (accountType == SELLER) {
		privKey = sellerWIF
	} else if (accountType == BUYER) {
		privKey = buyerWIF
	} else {
		print("Incorrect account type")		
		throw err;
	}

	const wallet = network.fromWIF(privKey)
	const info = await wallet.getInfo()
	let walletBalance = info.balance
	fn(walletBalance)
}



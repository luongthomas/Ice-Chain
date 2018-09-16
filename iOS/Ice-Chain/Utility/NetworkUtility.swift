//
//  BlockchainNetworkUtility.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/8/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation
import Alamofire

class NetworkUtility {
    
    let constants = Constants()
    
    
    func sampleNetwork() {
        Alamofire.request("https://httpbin.varvar/get").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }

    
    let jsonDecoder = JSONDecoder()
    
    func getAccounts() {
        sendRpcCommand(command: "listaccounts", parameters: []) { data, err in
            if let data = data {
                do {
                    let account = try self.jsonDecoder.decode(AccountBalance.self, from: data)
                    print(account.result.buyer)
                    print(account.result.seller)
                } catch {
                    print(error)
                }
            }
            if let err = err {
                print("\(err)")
            }
        }
    }
    
    func getAddressGroupings() {
        sendRpcCommand(command: "listaddressgroupings", parameters: [], completionHandler: { (data, err) in

            if let data = data {
                do {
                    Users.shared.sellerAddresses = [String]()
                    Users.shared.buyerAddresses = [String]()
                    let addresses = try self.jsonDecoder.decode(AccountAddress.self, from: data)
                    for address in addresses.result {
                        for account in address {
                            if let accountType = account.accountType {
                                if accountType == Users.shared.sellerType {
                                    Users.shared.sellerAddresses.append(account.address)
                                    Users.shared.sellerBalance = account.amount
                                } else if accountType == Users.shared.buyerType {
                                    Users.shared.buyerAddresses.append(account.address)
                                    Users.shared.buyerBalance = account.amount
                                }
                            }
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
            if let err = err {
                print("\(err)")
            }
            
            print("Seller addresses are: \(Users.shared.sellerAddresses) with amount of \(Users.shared.sellerBalance)")
            print("Buyer addresses are: \(Users.shared.buyerAddresses) with amount of \(Users.shared.buyerBalance)")
            
            }
        )
    }

    
    func deployContract() {
        
        let contractCode = constants.byteCode
        let gasLimit = constants.gasLimit
        let gasPrice = constants.gasPrice
        var senderAddress = Users.shared.currentAddress
        
        sendRpcCommand(command: "createcontract", parameters: [contractCode, gasLimit, gasPrice, senderAddress], completionHandler: { (data, err) in
            
            if let data = data {
                do {
                    let response = try self.jsonDecoder.decode(TransactionResponse.self, from: data)
                    
                    print("Transaction ID: \(response.result.txid)")
                    if let address = response.result.address {
                        print("Address: \(address)")
                        Deployed.shared.contractAddresses.append(address)
                    }
                    Deployed.shared.transactionIds.append(response.result.txid)
                    
                } catch {
                    print(error)
                }
            }
            if let err = err {
                print("\(err)")
            }
            
        })
    }
    
    func depositMoney() {
        
        let depositABI = constants.sendPaymentABI
        guard let contractAddress = Deployed.shared.contractAddresses.last else { return }
        let gasLimit = constants.gasLimit
        let gasPrice = constants.gasPrice
        let deposit = Contract.running.deposit / constants.qtumPricePerUSD
        let amountToSend = (deposit * 100).rounded() / 100
        var senderAddress = Users.shared.currentAddress
        
        if Contract.shared.depositor.rawValue == "SELLER" {
            senderAddress = Users.shared.sellerAddresses.last!
        } else if Contract.shared.depositor.rawValue == "BUYER" {
            senderAddress = Users.shared.buyerAddresses.last!
        } else {
            print("UNKNOWN SENDER ADDRESS")
        }
        
        sendRpcCommand(command: "sendtocontract", parameters: [contractAddress, depositABI, amountToSend, gasLimit, gasPrice, senderAddress], completionHandler: { (data, err) in
            
            if let data = data {
                do {
                    
                    let response = try self.jsonDecoder.decode(TransactionResponse.self, from: data)
                    
                    print("Transaction ID: \(response.result.txid)")
                    if let address = response.result.address {
                        print("Address: \(address)")
                        Deployed.shared.contractAddresses.append(address)
                    }
                    Deployed.shared.transactionIds.append(response.result.txid)
                    
                } catch {
                    print(error)
                }
            }
            if let err = err {
                print("\(err)")
            }
            
        })
    }
    
    
    func checkConfirmation(txid: String, completion: @escaping(Bool)->()) {
        sendRpcCommand(command: "gettransaction", parameters: [txid], completionHandler: { (data, err) in
            
            if let data = data {
                do {
                    let response = try self.jsonDecoder.decode(Txid.self, from: data)
                    
                    let confirmations = response.result.confirmations
                    if confirmations > 0 {
                        print("Confirmations greater than 0")
                        completion(true)
                    } else {
                        print("No confirmations yet")
                        completion(false)
                    }
                    
                } catch {
                    print(error)
                }
            }
            if let err = err {
                print("\(err)")
            }
            
        })
    }
    
    // Sends back data and it must be encoded based on which data structure is expected
    func sendRpcCommand(command: String, parameters: [Any], completionHandler: @escaping (Data?, Error?) -> ()) {
        
        // TODO: Check command is valid
        // TODO: Check Parameters?
        
        let parameters: [String: Any] = [
            "jsonrpc": "1.0",
            "id": "iOS",
            "method": command,
            "params": parameters
        ]
        
        let base = "https://qtum-testnet.iame.io/qtum-rpc?"
        let key = "apiKey=585e54431550c0e6105acaeee44561e8"
        let url = base + key
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
            case .success( _):
                print(response.value)
                completionHandler(response.data, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    
    
    
}

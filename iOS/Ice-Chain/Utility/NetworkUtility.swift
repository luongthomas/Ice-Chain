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
    
    
    // From EC2
    func getContracts(completionHandler: @escaping (Contracts?, Error?) -> ()) {
        let url = "http://35.165.80.135:5124/get-all-contracts"
        
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success( _):
                do {
                    let contracts = try self.jsonDecoder.decode(Contracts.self, from: response.data!) as Contracts
                    completionHandler(contracts, nil)
                } catch {
                    completionHandler(nil, error)
                }
                
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func sendNewContractToDatabase(contract: ContractDB, completionHandler: @escaping (ObjectId?, Error?) -> ()) {
        let contract = CurrentContract.shared
        print("Sending ContractDB to DB")
        let params: [String: Any] = [
            "contractName" : contract.contractName,
            "deadline" : contract.deadline,
            "depositLimit" : contract.depositLimit,
            "depositorAddress" : contract.depositorAddress,
            "depositorEmail" : contract.depositorEmail,
            "depositorName" : contract.depositorName,
            "description" : contract.description,
            "maxTemperature" : contract.maxTemperature,
            "minTemperature" : contract.minTemperature,
            "otherPartyAddress" : contract.otherPartyAddress,
            "otherPartyEmail" : contract.otherPartyEmail,
            "otherPartyName" : contract.otherPartyName,
            "status" : contract.status,
            "cargoValue" : contract.cargoValue,
            "contractAddress" : contract.contractAddress,
            "owner" : contract.owner,
            "depositRate" : contract.depositRate
        ]
        
        let url: String = "http://35.165.80.135:5124/contract-create"
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
            case .success( _):
                do {
                    let objectId = try self.jsonDecoder.decode(ObjectId.self, from: response.data!) as ObjectId
                    completionHandler(objectId, nil)
                } catch {
                    completionHandler(nil, error)
                }
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func getAccountInfo(account: String, completionHandler: @escaping (AccountInfo?, Error?) -> ()) {
        var url: String = "http://35.165.80.135:5124/accountInfo/"
        var accountType = ""
        if (account == "Seller" || account == "Buyer") {
            accountType = account
            url += accountType
        } else {
            print("Error in choosing account")
        }
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success( _):
                do {
                    let accountInfo = try self.jsonDecoder.decode(AccountInfo.self, from: response.data!) as AccountInfo
                    completionHandler(accountInfo, nil)
                } catch {
                    completionHandler(nil, error)
                }
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func updateContractStatus(contractStatus: ContractStatus, completionHandler: @escaping (String?, Error?) -> ()) {
        let contract = CurrentContract.shared
        
        var statusValue = 0
        
        switch contractStatus {
        case .NOT_RUNNING:
            statusValue = 0
        case .RUNNING:
            statusValue = 1
        case .FAILED:
            statusValue = 2
        case .COMPLETED:
            statusValue = 3
        }
        
        let params: [String: Any] = [
            "_id" : contract._id,
            "contractStatus" : statusValue
        ]
        
        let url: String = "http://35.165.80.135:5124/update-status"
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.response?.statusCode {
            case 200:
                completionHandler("Successfully updated", nil)
            default:
                completionHandler(nil, response.error)
            }
        }
    }

//    func deployContract() {
//
//        let contractCode = constants.byteCode
//        let gasLimit = constants.gasLimit
//        let gasPrice = constants.gasPrice
//        var senderAddress = Users.shared.currentAddress
//
//        sendRpcCommand(command: "createcontract", parameters: [contractCode, gasLimit, gasPrice, senderAddress], completionHandler: { (data, err) in
//
//            if let data = data {
//                do {
//                    let response = try self.jsonDecoder.decode(TransactionResponse.self, from: data)
//
////                    print("Transaction ID: \(response.result.txid)")
//                    if let address = response.result.address {
////                        print("Address: \(address)")
//                        Deployed.shared.contractAddresses.append(address)
//                    }
//                    Deployed.shared.transactionIds.append(response.result.txid)
//
//                } catch {
//                    print(error)
//                }
//            }
//            if let err = err {
//                print("\(err)")
//            }
//
//        })
//    }
    
//    func depositMoney() {
//
//        let depositABI = constants.sendPaymentABI
//        guard let contractAddress = Deployed.shared.contractAddresses.last else { return }
//        let gasLimit = constants.gasLimit
//        let gasPrice = constants.gasPrice
//        let deposit = Contract.running.deposit / constants.qtumPricePerUSD
//        let amountToSend = (deposit * 100).rounded() / 100
//        var senderAddress = Users.shared.currentAddress
//
//        if Contract.shared.depositor.rawValue == "SELLER" {
//            senderAddress = Users.shared.sellerAddresses.last!
//        } else if Contract.shared.depositor.rawValue == "BUYER" {
//            senderAddress = Users.shared.buyerAddresses.last!
//        } else {
//            print("UNKNOWN SENDER ADDRESS")
//        }
//
//        sendRpcCommand(command: "sendtocontract", parameters: [contractAddress, depositABI, amountToSend, gasLimit, gasPrice, senderAddress], completionHandler: { (data, err) in
//
//            if let data = data {
//                do {
//
//                    let response = try self.jsonDecoder.decode(TransactionResponse.self, from: data)
//
//                    print("Transaction ID: \(response.result.txid)")
//                    if let address = response.result.address {
//                        print("Address: \(address)")
//                        Deployed.shared.contractAddresses.append(address)
//                    }
//                    Deployed.shared.transactionIds.append(response.result.txid)
//
//                } catch {
//                    print(error)
//                }
//            }
//            if let err = err {
//                print("\(err)")
//            }
//
//        })
//    }
    
    
//    func checkConfirmation(txid: String, completion: @escaping(Bool)->()) {
//        sendRpcCommand(command: "gettransaction", parameters: [txid], completionHandler: { (data, err) in
//
//            if let data = data {
//                do {
//                    let response = try self.jsonDecoder.decode(Txid.self, from: data)
//
//                    let confirmations = response.result.confirmations
//                    if confirmations > 0 {
//                        print("Confirmations greater than 0")
//                        completion(true)
//                    } else {
//                        print("No confirmations yet")
//                        completion(false)
//                    }
//
//                } catch {
//                    print(error)
//                }
//            }
//            if let err = err {
//                print("\(err)")
//            }
//
//        })
//    }
//
//    // Sends back data and it must be encoded based on which data structure is expected
//    func sendRpcCommand(command: String, parameters: [Any], completionHandler: @escaping (Data?, Error?) -> ()) {
//
//        // TODO: Check command is valid
//        // TODO: Check Parameters?
//
//        let parameters: [String: Any] = [
//            "jsonrpc": "1.0",
//            "id": "iOS",
//            "method": command,
//            "params": parameters
//        ]
//
//        let base = "https://qtum-testnet.iame.io/qtum-rpc?"
//        let key = "apiKey=585e54431550c0e6105acaeee44561e8"
//        let url = base + key
//
//        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
//
//            switch response.result {
//            case .success( _):
////                print(response.value)
//                completionHandler(response.data, nil)
//            case .failure(let error):
//                completionHandler(nil, error)
//            }
//        }
//    }
    
    
    
    
}

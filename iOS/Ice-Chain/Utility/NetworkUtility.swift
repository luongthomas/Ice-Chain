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
    
    func sampleNetwork() {
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
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
    
    
        //        let parameters: [String: Any] = [
        //            "jsonrpc": "1.0",
        //            "id":"iOS",
        //            "method": "sendtocontract",
        //            "params": [
        //                "00bd14e55565638ea1c85fdb8d501ba99a791975",
        //                "3ccfd60b",
        //                0,
        //                190000,
        //                0.0000004,
        //                "qHkSLraGVW1PqYSizqJDLGT8GSwSKc7Gaf"
        //            ]
        //        ]

    
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
            var buyer = Buyer()
            var seller = Seller()

            if let data = data {
                do {
                    let addresses = try self.jsonDecoder.decode(AccountAddress.self, from: data)
                    for address in addresses.result {
                        for account in address {
                            if let accountType = account.accountType {
                                if accountType == seller.type {
                                    seller.balance += account.amount
                                    seller.addresses.append(account.address)
                                } else if accountType == buyer.type {
                                    buyer.balance += account.amount
                                    buyer.addresses.append(account.address)
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
            
            print("Seller addresses are: \(seller.addresses) with amount of \(seller.balance)")
            print("Buyer addresses are: \(buyer.addresses) with amount of \(buyer.balance)")
            
            }
        )
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
                
                completionHandler(response.data, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
}

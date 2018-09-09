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

    
    func getAccounts() {
        sendRpcCommand(command: "listaccounts", parameters: []) { accounts, error in
            if let accounts = accounts {
                do {
                    let jsonDecoder = JSONDecoder()
                    let account = try jsonDecoder.decode(Accounts.self, from: accounts)
                    print(account.result.buyer)
                    print(account.result.seller)
                } catch {
                    print(error)
                }
            }
            if let error = error {
                print("\(error)")
            }
        }
    }
    
    
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

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
    
    
    func communicateWithBlockchain() {
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
        
        let parameters: [String: Any] = [
            "jsonrpc": "1.0",
            "id": "iOS",
            "method": "getblockchaininfo",
            "params": []
        ]
        
        let url = "https://qtum-testnet.iame.io/qtum-rpc?apiKey=585e54431550c0e6105acaeee44561e8"
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            //            print(response)
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
        }
    }
    
}

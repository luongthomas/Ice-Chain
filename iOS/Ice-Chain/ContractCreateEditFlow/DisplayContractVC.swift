//
//  ConfirmContractVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/10/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class DisplayContractVC: UIViewController {
    
    @IBOutlet weak var contractName: UILabel!
    @IBOutlet weak var buyerEmail: UILabel!
    @IBOutlet weak var cargoType: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var deadlineDate: UILabel!
    @IBOutlet weak var cargoValue: UILabel!
    @IBOutlet weak var depositor: UILabel!
    @IBOutlet weak var depositRate: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var depositValueQtum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let unixTimestamp = CurrentContract.shared.deadline
        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateFormatString = dateFormatter.string(from: date)

        contractName.text = CurrentContract.shared.contractName
        buyerEmail.text = CurrentContract.shared.otherPartyEmail
        cargoType.text = CurrentContract.shared.description
        minTemp.text = "\(CurrentContract.shared.minTemperature) C"
        maxTemp.text = "\(CurrentContract.shared.maxTemperature) C"
        deadlineDate.text = "\(dateFormatString)"
        cargoValue.text = "\(CurrentContract.shared.cargoValue) USD"
        depositor.text = CurrentContract.shared.depositorName
        depositRate.text = "\(CurrentContract.shared.depositRate) %"
        depositValueQtum.text = "\(CurrentContract.shared.depositLimit)"
        owner.text = CurrentContract.shared.owner
    }
    
    @IBAction func confirmContract(_ sender: Any) {
        CurrentContract.shared.status = Constants().ON_APPROVAL
        print("Confirming Contract")
        
        // TODO: Send all information to database
        NetworkUtility().sendNewContractToDatabase(contract: CurrentContract.shared) { (dataStr, err) in
            if let data = dataStr {
                print(data)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToGlobal(segue: UIStoryboardSegue) {}
}

//
//  ContractsViewController.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 10/31/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit


class ContractsTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var contracts = [ContractDB]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadRealContracts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80

//        if let savedContracts = loadContracts() {
//            contracts += savedContracts
//        }
//        else {
//            // Load the sample data.
//            loadSampleContracts()
//        }
//
//        print("")
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contracts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ContractsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContractsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ContractsTableViewCell.")
        }
        
        // Fetches the appropriate contract for the data source layout.
        let contract = contracts[indexPath.row]
        
        cell.contractNameLabel.text = contract.contractName
        
        let contractStatus = contract.status
        
        let ON_APPROVAL = 0
        let RUNNING = 1
        let FAILED = 2
        let COMPLETED = 3
        
        switch contractStatus {
        case ON_APPROVAL:
            cell.contractImageView.image = UIImage(named: "on_approval")
            cell.contractStatusLabel.text = "On Approval"
        case RUNNING:
            cell.contractImageView.image = UIImage(named: "running")
            cell.contractStatusLabel.text = "Running"
        case FAILED:
            cell.contractImageView.image = UIImage(named: "failed")
            cell.contractStatusLabel.text = "Failed"
        case COMPLETED:
            cell.contractImageView.image = UIImage(named: "completed")
            cell.contractStatusLabel.text = "Completed"
        default:
            cell.contractImageView.image = UIImage(named: "not_running")
            cell.contractStatusLabel.text = "Unknown status"
        }
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            meals.remove(at: indexPath.row)
//            saveMeals()
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    //MARK: - Navigation
    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        super.prepare(for: segue, sender: sender)
//
//        switch(segue.identifier ?? "") {
//
//        case "AddItem":
//            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
//
//        case "ShowDetail":
//            guard let mealDetailViewController = segue.destination as? MealViewController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//
//            guard let selectedMealCell = sender as? MealTableViewCell else {
//                fatalError("Unexpected sender: \(sender)")
//            }
//
//            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
//                fatalError("The selected cell is not being displayed by the table")
//            }
//
//            let selectedMeal = meals[indexPath.row]
//            mealDetailViewController.meal = selectedMeal
//
//        default:
//            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
//        }
//    }
    
    
    //MARK: Actions
    
//    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
//
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                // Update an existing meal.
//                meals[selectedIndexPath.row] = meal
//                tableView.reloadRows(at: [selectedIndexPath], with: .none)
//            }
//            else {
//                // Add a new meal.
//                let newIndexPath = IndexPath(row: meals.count, section: 0)
//
//                meals.append(meal)
//                tableView.insertRows(at: [newIndexPath], with: .automatic)
//            }
//
//            // Save the meals.
//            saveMeals()
//        }
//    }
    
    @IBAction func unwindToGlobal(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contract = contracts[indexPath.row]
        let dialogUtil = DialogUtility()
        
        NetworkUtility().getConfirmations(txid: contract.txid) { (confirmations, err) in
            
            if let err = err {
                dialogUtil.displayMyAlertMessage(vc: self, userMessage: "[ERR]: \(err)")
                return
            }
            
            guard let confirms = confirmations else {
                dialogUtil.displayMyAlertMessage(vc: self, userMessage: "[ERR]: Unable to get number of confirmations.  Maybe server is having issues or network connectivity is not good.")
                return
            }
            
            if (confirms < 1) {
                dialogUtil.displayMyAlertMessage(vc: self, userMessage: "Number of confirmations is not more than 2, please wait to try again")
                return
            } else {
                print("Number of confirmations are: \(confirms)")
                switch (contract.status) {
                default:
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "contractTemplate") as? ViewContractTemplateVC else { return }
                    vc.contract = contract
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    private func loadRealContracts() {
        let networkUtility = NetworkUtility()
        networkUtility.getContracts { (items, err) in
            self.contracts.removeAll(keepingCapacity: true)
            if let contractList = items {
                for i in contractList.items {
                    self.contracts.append(i)
                }
                self.tableView.reloadData()
            }
            print("Items in contracts: \(self.contracts.count)")
            
            if let err = err {
                print("Error: \(err)")
            }
        }
        
    }
    
    
    //MARK: Private Methods
    
//    private func loadSampleContracts() {
//        let contract1 = Contract(type: "running")
//        let contract2 = Contract(type: "executed")
//        let contract3 = Contract(type: "running")
//
//        contracts += [contract1, contract2, contract3]
//        print("")
//    }

//    private func saveMeals() {
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
//        if isSuccessfulSave {
//            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
//        } else {
//            os_log("Failed to save meals...", log: OSLog.default, type: .error)
//        }
//    }

//    private func loadContracts() -> [Contract]?  {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: Contract.ArchiveURL.path) as? [Contract]
//    }

}

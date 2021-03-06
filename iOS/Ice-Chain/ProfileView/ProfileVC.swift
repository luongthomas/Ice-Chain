//
//  ViewController.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 8/20/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var hamburgerView: UIView!
    @IBOutlet weak var trailingHamburger: NSLayoutConstraint!
    @IBOutlet weak var leadingHamburger: NSLayoutConstraint!
    @IBOutlet weak var refreshBtn: UIButton!
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var qtumAmount: UILabel!
    @IBOutlet weak var qtumAddress: UILabel!
    
    @IBOutlet weak var buyerBtn: UIButton!
    @IBOutlet weak var sellerBtn: UIButton!
    
    @IBOutlet weak var loggedInUserLbl: UILabel!
    @IBOutlet weak var createContractBtn: Button!
    
    var hamburgerMenuIsVisible = false

    let networkUtility = NetworkUtility()
    
    @IBAction func handleButtonPress(_ sender: Any) {
        refreshAccounts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Users.shared.setSellerAsCurrentUser()
        updateBuyerInfo { (success, err) in }
        updateSellerInfo { (success, err) in }
        refreshAccounts()
        registerResetNotification()

        sellerBtn.addTarget(self, action: #selector(refreshAccounts), for: .touchUpInside)
        buyerBtn.addTarget(self, action: #selector(refreshAccounts), for: .touchUpInside)
    }
    
    private func registerResetNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(resetContract(notification:)), name: NSNotification.Name(rawValue: "resetCurrentContract"), object: nil)
    }
    
    @objc func resetContract(notification: NSNotification) {
        CurrentContract.shared = ContractDB.init()
        print(CurrentContract.shared.contractName)
    }

    @objc private func refreshAccounts() {
        if Users.shared.currentUser == "Buyer" {
            self.updateBuyerInfo {(success, err) in
                if let err = err { print(err); return }
                self.updateBuyerUI()
            }
        } else {
            self.updateSellerInfo {(success, err) in
                if let err = err { print(err); return }
                self.updateSellerUI()
            }
        }
    }
    
    func updateBuyerInfo(completionHandler: @escaping (Bool, Error?) -> ()) {
        networkUtility.getAccountInfo(account: "Buyer") { (accountInfo, err) in
            if let err = err {
                completionHandler(false, err)
                return
            }
            guard let info = accountInfo else { return }
            Users.shared.buyerAddresses.append(info.address)
            Users.shared.buyerBalance = info.balance
            completionHandler(true, nil)
        }
    }
    
    func updateSellerInfo(completionHandler: @escaping (Bool, Error?) -> ()) {
        networkUtility.getAccountInfo(account: "Seller") { (accountInfo, err) in
            if let err = err {
                completionHandler(false, err)
                return
            }
            guard let info = accountInfo else { return }
            Users.shared.sellerAddresses.append(info.address)
            Users.shared.sellerBalance = info.balance
            completionHandler(true, nil)
        }
    }

    @IBAction func openHamburger(_ sender: Any) {
        // if hamburger menu is NOT visible, then move the hamburgerView back to where it used to be
        if !hamburgerMenuIsVisible {
            leadingHamburger.constant = 200
            
            // This constant is NEGATIVE because we are moving it to 150 points OUTWARD and that means -150
            trailingHamburger.constant = 200
            
            // 1
            hamburgerMenuIsVisible = true
            
        } else {
            // If hamburger menu IS visible, then move the view back to its original position
            leadingHamburger.constant = 0
            trailingHamburger.constant = 0
            
            // 2
            hamburgerMenuIsVisible = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            print("The animation is complete!")
        }
    }
    
    @IBAction func changeToBuyer(_ sender: Any) {
        updateBuyerUI()
    }
    
    func updateBuyerUI() {
        userImage.image = UIImage(named: "Buyer")
        userEmail.text = "buyer@gmail.com"
        qtumAddress.text = Users.shared.buyerAddresses.first
        qtumAmount.text = "\(Users.shared.buyerBalance) QTUM"
        Users.shared.setBuyerAsCurrentUser()
        loggedInUserLbl.text = "Buyer"
        createContractBtn.isEnabled = false
    }
    
    @IBAction func changeToSeller(_ sender: Any) {
        updateSellerUI()
    }
    
    func updateSellerUI() {
        userImage.image = UIImage(named: "Seller")
        userEmail.text = "seller@gmail.com"
        qtumAddress.text = Users.shared.sellerAddresses.first
        qtumAmount.text = "\(Users.shared.sellerBalance) QTUM"
        Users.shared.setSellerAsCurrentUser()
        loggedInUserLbl.text = "Seller"
        createContractBtn.isEnabled = true
    }
    
    @IBAction func transportationBtn(_ sender: Any) {
        State.viewContractGraph = false
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "scanResultsVC") as! ScanResultsViewController
        self.navigationController?.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func createContractBtn(_ sender: Any) {
        // Reset Contract (notification is in CreateContractVC)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetCurrentContract"), object: nil)
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "contractFlowTemplate") as! CreateContractVC
        self.navigationController?.present(newViewController, animated: true, completion: nil)
    }
}

@IBDesignable
public class Button: UIButton {
    @IBInspectable public override var borderColor:UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable public override var borderWidth:CGFloat  {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable public override var cornerRadius:CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

public class TextField: UITextField, UITextFieldDelegate {
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        delegate = self
    }
}

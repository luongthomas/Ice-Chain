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
    
    var hamburgerMenuIsVisible = false
    
    let networkUtility = NetworkUtility()
    
    @IBAction func handleButtonPress(_ sender: Any) {
        networkUtility.getAddressGroupings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkUtility.getAddressGroupings()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // change 2 to desired number of seconds
            
            self.sellerBtn.sendActions(for: .touchUpInside)
        }
        Users.shared.setSellerAsCurrentUser()
        
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
        userImage.image = UIImage(named: "Buyer")
        userEmail.text = "buyer@gmail.com"
        qtumAddress.text = Users.shared.buyerAddresses.first
        qtumAmount.text = "\(Users.shared.buyerBalance) QTUM"
        Users.shared.setBuyerAsCurrentUser()
        
    }
    
    @IBAction func changeToSeller(_ sender: Any) {
        userImage.image = UIImage(named: "Seller")
        userEmail.text = "seller@gmail.com"
        qtumAddress.text = Users.shared.sellerAddresses.first
        qtumAmount.text = "\(Users.shared.sellerBalance) QTUM"
        Users.shared.setSellerAsCurrentUser()
        
    }
    
    @IBAction func transportationBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "scanResultsVC") as! ScanResultsViewController
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



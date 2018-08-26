//
//  ViewController.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 8/20/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var hamburgerView: UIView!
    @IBOutlet weak var trailingHamburger: NSLayoutConstraint!
    @IBOutlet weak var leadingHamburger: NSLayoutConstraint!
    
    var hamburgerMenuIsVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openHamburger(_ sender: Any) {
        // if hamburger menu is NOT visible, then move the hamburgerView back to where it used to be
        if !hamburgerMenuIsVisible {
            leadingHamburger.constant = 150
            
            // This constant is NEGATIVE because we are moving it to 150 points OUTWARD and that means -150
            trailingHamburger.constant = 150
            
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
    
}

@IBDesignable
public class Button: UIButton {
    @IBInspectable public var borderColor:UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable public var borderWidth:CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable public var cornerRadius:CGFloat {
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
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        delegate = self
    }
}

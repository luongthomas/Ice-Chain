//
//  ViewController.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 8/20/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

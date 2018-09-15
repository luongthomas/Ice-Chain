//
//  LineChart1ViewController.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/15/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit
class ChartVC: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        let myViewController = LineChart1ViewController(nibName: "LineChart1ViewController", bundle: nil)
        self.present(myViewController, animated: true, completion: nil)
    }
}

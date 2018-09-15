//
//  ChartVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/15/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit
class ChartVC: UIViewController {
    
    
    @IBAction func showGraph(_ sender: Any) {
        let myViewController = LineChart1ViewController(nibName: "LineChart1ViewController", bundle: nil)
        self.navigationController!.pushViewController(myViewController, animated: true)
    }
}

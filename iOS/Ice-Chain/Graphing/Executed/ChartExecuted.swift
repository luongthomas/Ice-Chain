//
//  ChartExecuted.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/15/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit
class ChartExecuted: UIViewController {
    
    @IBAction func showGraph(_ sender: Any) {
        let myViewController = LineChart2ViewController(nibName: "LineChart2ViewController", bundle: nil)
        self.navigationController!.pushViewController(myViewController, animated: true)
    }
}

//
//  TemperatureViewController.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 10/24/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class TemperatureViewController: UIViewController {
    
    private let viewModel: TemperatureViewModelType
    
    init(with viewModel: TemperatureViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var temperatureLabel: UILabel = {
        let textView = UILabel()
        textView.text = "Temperature"
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var temperatureButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.borderColor = .blue
        button.borderWidth = 2
        button.setTitle("Get Temperature", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTempBtnPress), for: .touchUpInside)
        return button
    }()

    @objc func handleTempBtnPress() {
        print("Pressed Temperature Btn")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(temperatureLabel)
        view.addSubview(temperatureButton)
        
        setupLayout()
    }
    
    private func setupLayout() {
        temperatureLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        temperatureLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        temperatureButton.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 25).isActive = true
        temperatureButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        temperatureButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        temperatureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

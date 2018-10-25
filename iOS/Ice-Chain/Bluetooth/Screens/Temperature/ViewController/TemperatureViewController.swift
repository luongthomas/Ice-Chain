//
//  TemperatureViewController.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 10/24/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit
import RxBluetoothKit
import RxSwift
import RxCocoa

class TemperatureViewController: UIViewController {
    
    private let viewModel: TemperatureViewModelType
    
    private let disposeBag = DisposeBag()
    
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
        textView.font = UIFont.boldSystemFont(ofSize: 26)
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
        
        // 0 will signify returning one temperature
        self.viewModel.writeToCharacteristic(value: "0")

        
    }
    
    private func bindViewModel() {
        subscribeViewModelOutputs()
    }
    
    private func subscribeViewModelOutputs() {
        subscribeCharacteristicActionOutput(viewModel.characteristicReadOutput)
        subscribeCharacteristicActionOutput(viewModel.updatedValueAndNotificationOutput) { output in
            let filteredOutput = output.digits
            guard let tempDouble = Double(filteredOutput) else { return }
            var tempText = ""
            if tempDouble >= 0.0 {
                tempText = "+\(tempDouble)\u{00B0} Celcius"
            } else {
                tempText = "-\(tempDouble)\u{00B0} Celcius"
            }
            
            self.temperatureLabel.text = tempText
            
        }
        subscribeCharacteristicActionOutput(viewModel.characteristicWriteOutput)

    }
    
    private func subscribeCharacteristicOutput(_ outputStream: Observable<Characteristic>) {
        outputStream.subscribe(onNext: { [unowned self] output in
            if let data = output.value {
                self.temperatureLabel.text = String(data: data, encoding: .ascii)
            }
            
            
        }).disposed(by: disposeBag)
    }
    
    private func subscribeCharacteristicActionOutput(_ outputStream: Observable<Result<Characteristic, Error>>,
                                                     additionalAction: ((String) -> Void)? = nil) {
        outputStream.subscribe(onNext: { [unowned self] result in
            switch result {
            case .success(let value):
                if let data = value.characteristic.value {
                    let output = String(data: data, encoding: .ascii) ?? ""
                    print(output)
                    additionalAction?(output)
                }
                
            case .error(let error):
                let bluetoothError = error as? BluetoothError
                let message = bluetoothError?.description ?? error.localizedDescription
                self.showAlert(title: Constant.Strings.titleError, message: message)
            }
        }).disposed(by: disposeBag)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setNotificationsState(enabled: true)
        bindViewModel()
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
    
    private func showAlert(title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Constant.Strings.titleOk, style: .default) { _ in
            self.dismiss(animated: true)
        }
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

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
    var isTempArray = false
    var prevOutput = ""
    var totalTempString = ""
    
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
    
    var dataCount: UILabel = {
        let textView = UILabel()
        textView.text = "0 data points"
        textView.font = UIFont.boldSystemFont(ofSize: 26)
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var graphButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.borderColor = .blue
        button.borderWidth = 2
        button.setTitle("Refresh Data", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleGraphBtnPress), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setNotificationsState(enabled: true)
        bindViewModel()
        view.backgroundColor = .white
        State.tempArray = []
        if (State.viewContractGraph == false) {
            view.addSubview(temperatureLabel)
            view.addSubview(temperatureButton)
            setupLayout()
        } else {
            getTempArrayData()
            showGraphButton()
        }
    }
    

    @objc func handleTempBtnPress() {
        print("Pressed Temperature Btn")
        
        // 0 will signify returning one temperature
        isTempArray = false
        self.viewModel.writeToCharacteristic(value: "0")
    }
    
    private func showGraphButton() {
        view.addSubview(graphButton)
        view.addSubview(dataCount)
        
        dataCount.heightAnchor.constraint(equalToConstant: 25).isActive = true
        dataCount.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        dataCount.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        dataCount.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        graphButton.topAnchor.constraint(equalTo: dataCount.bottomAnchor, constant: 25).isActive = true
        graphButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        graphButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        graphButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func getTempArrayData() {
        isTempArray = true
        self.viewModel.writeToCharacteristic(value: "1")
    }
    
    @objc private func handleGraphBtnPress() {
        if graphButton.titleLabel?.text == "Refresh Data" {
            if (totalTempString.isEmpty) {
                return
            }
            let cleanedTempString = totalTempString.trimmingCharacters(in: .whitespacesAndNewlines)
            let stringTempArray = cleanedTempString.components(separatedBy: " ")
            State.tempArray = stringTempArray.map{ NSString(string: $0).doubleValue }

            dataCount.text = "\(State.tempArray.count) Data points"
            
            if State.tempArray.count > 20 {
                graphButton.titleLabel?.text = "Show Graph"
                graphButton.setTitle("Show Graph", for: .normal)
                return
            }
        }
        
        if graphButton.titleLabel?.text == "Show Graph" {
            let myViewController = LineChart2ViewController(nibName: "LineChart2ViewController", bundle: nil)
            self.navigationController!.pushViewController(myViewController, animated: true)
        }
    }
    
    private func bindViewModel() {
        subscribeViewModelOutputs()
    }
    
    private func subscribeViewModelOutputs() {
        subscribeCharacteristicActionOutput(viewModel.characteristicReadOutput)
        subscribeCharacteristicActionOutput(viewModel.updatedValueAndNotificationOutput) { output in
            if !self.isTempArray {
                let filteredOutput = output.digits
                guard let tempDouble = Double(filteredOutput) else { return }
                var tempText = ""
                if tempDouble >= 0.0 {
                    tempText = "+\(tempDouble)\u{00B0} Celcius"
                } else {
                    tempText = "-\(tempDouble)\u{00B0} Celcius"
                }
                self.temperatureLabel.text = tempText
                
            } else {
                if output != self.prevOutput {
                    self.totalTempString += output
                }
                
                self.prevOutput = output
            }
        }
        subscribeCharacteristicActionOutput(viewModel.characteristicWriteOutput)

    }
    
    private func subscribeCharacteristicOutput(_ outputStream: Observable<Characteristic>) {
        outputStream.subscribe(onNext: { [unowned self] output in
            if self.isTempArray == false {
                if let data = output.value {
                    self.temperatureLabel.text = String(data: data, encoding: .ascii)
                }
            } else {
                // Never Hits
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
                    additionalAction?(output)
                }
                
            case .error(let error):
                let bluetoothError = error as? BluetoothError
                let message = bluetoothError?.description ?? error.localizedDescription
                self.showAlert(title: Constant.Strings.titleError, message: message)
            }
        }).disposed(by: disposeBag)
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

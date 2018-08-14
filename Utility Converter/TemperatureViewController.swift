//
//  TemperatureViewController.swift
//  Utility Converter
//
//  Created by ismail ali on 19/03/2018.
//  Copyright © 2018 Ismail Ali. All rights reserved.
//

import UIKit

class TemperatureViewController: UIViewController {
    
    @IBOutlet var barBtnSave: UIBarButtonItem!
    
    @IBOutlet var fahrenheitTextField: UITextField!
    
    @IBOutlet var celsiusTextField: UITextField!
    
        @IBOutlet var kelvinTextField: UITextField!
    
    var previousNumber : Double!
    
    
    let defaults = UserDefaults.standard
    
    var keyBoardHeight:CGFloat = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideSaveButton()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    func hideSaveButton(){
        self.barBtnSave.title = ""
        self.barBtnSave.isEnabled = false
    }
    
    func showSaveButton(){
        self.barBtnSave.title = "💾"
        self.barBtnSave.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        var tabBarFrame: CGRect = CGRect(x: self.view.frame.minX, y: self.view.frame.maxY, width: self.view.frame.width, height: 30.0)
        tabBarFrame.origin.y = self.view.frame.maxY
        self.tabBarController?.tabBar.frame = tabBarFrame
        
        //add a notification for when the keyboard shows and call keyboardWillShow when the keyboard is to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //this moves the tab bar above the keyboard for all devices
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyBoardHeight = keyboardSize.origin.y - keyboardSize.height - (self.tabBarController?.tabBar.frame.height)!
        }
        
        var tabBarFrame: CGRect = (self.tabBarController?.tabBar.frame)!
        
        tabBarFrame.origin.y = self.keyBoardHeight
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.tabBarController?.tabBar.frame = tabBarFrame })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //this moves the tab bar above the keyboard for all devices
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyBoardHeight = keyboardSize.origin.y - keyboardSize.height - (self.tabBarController?.tabBar.frame.height)!
        }
        
        var tabBarFrame: CGRect = (self.tabBarController?.tabBar.frame)!
        
        tabBarFrame.origin.y = self.view.frame.maxY-(self.tabBarController?.tabBar.frame.height)!
        
        // self.tabBarController?.tabBar.frame = tabBarFrame
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.tabBarController?.tabBar.frame = tabBarFrame })
    }
    
    
    
    
    
    
    func saveHistory(){
        
        //  var histories = [String]()
        self.view.endEditing(true)
        guard let celsius = self.celsiusTextField.text, !celsius.isEmpty else {
            
            return
        }
        
        guard let fahrenheit = self.fahrenheitTextField.text, !fahrenheit.isEmpty else {
            
            return
        }
        
        guard let kelvin = self.kelvinTextField.text, !kelvin.isEmpty else {
            
            return
        }
        
        let history = celsius+" Celsius = "+fahrenheit+" Fahrenheit = "+kelvin+" Kelvin"
        
        if UserDefaults.standard.object(forKey: "temperatureHistory") != nil {
            
            var getHistories = defaults.array(forKey: "temperatureHistory") as! [String]  //getting the current history array that has already been stored
            
            getHistories.append(history) // adding new history
            
            
            //adding one history from the head and removing the old one from the tail
            if getHistories.count > 5 {
                
                getHistories.remove(at: 0) // removing the old history
                
                
            }
            
            
            defaults.set(getHistories, forKey: "temperatureHistory") // replacing old histories array with the new histories array
            
        } else {
            defaults.set([history], forKey: "temperatureHistory")
        }
        
        defaults.synchronize()
    }
    
    
    
    
    
    
    
    @IBAction func barBtnSave(_ sender: UIBarButtonItem) {
        self.hideSaveButton()
        
        self.saveHistory()
        
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        if sender.text != "" {
            

            
            self.showSaveButton()
            
            if sender == self.celsiusTextField {
                if let number = Double(sender.text!){

                    previousNumber = number
                    
                    let goodUnit = UnitTemperature.celsius
                    let goodWeight:Measurement = Measurement(value: number, unit: goodUnit)
                    
                    self.fahrenheitTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .fahrenheit).value))
                    
                    self.kelvinTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .kelvin).value))
                    
                } else {
                    
                    print("error")
                    
                    
                    if previousNumber != nil {
                        sender.text = String(describing: previousNumber!)
                    }
                    
                }
                
                
            }
            
            if sender == self.fahrenheitTextField {
                
                if let number = Double(sender.text!){
                    
                    previousNumber = number
                    
                    let goodUnit = UnitTemperature.fahrenheit
                    let goodWeight:Measurement = Measurement(value: number, unit: goodUnit)
                    
                    self.celsiusTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .celsius).value))
                    
                    self.kelvinTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .kelvin).value))
                    
                } else {
                    
                    print("error")
                    
                    
                    if previousNumber != nil {
                        sender.text = String(describing: previousNumber!)
                    }
                    
                }
            }
            
            
            if sender == self.kelvinTextField {
                
                if let number = Double(sender.text!){
                    
                    previousNumber = number
                    
                    let goodUnit = UnitTemperature.kelvin
                    let goodWeight:Measurement = Measurement(value: number, unit: goodUnit)
                    
                    self.celsiusTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .celsius).value))
                    
                    self.fahrenheitTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .fahrenheit).value))
                    
                    
                } else {
                    
                    print("error")
                    
                    
                    if previousNumber != nil {
                        sender.text = String(describing: previousNumber!)
                    }
                    
                }
            }
            
            
        }  else {
            
            self.celsiusTextField.text = ""
            self.fahrenheitTextField.text = ""
            self.kelvinTextField.text = ""
            
            
            self.hideSaveButton()
            
            previousNumber = 0
            
        }
        
        
        
        
        
    }
    


    func roundToFourDecimalPlaces(double : Double) -> Double{
        return  (double * 10000).rounded()/10000
    }
    
    
}

//
//  SpeedViewController.swift
//  Utility Converter
//
//  Created by ismail ali on 19/03/2018.
//  Copyright © 2018 Ismail Ali. All rights reserved.
//

import UIKit

class LiquidViewController : UIViewController {
    
    
    
    @IBOutlet var barBtnSave: UIBarButtonItem!
    @IBOutlet var gallonsTextField: UITextField!
    
    @IBOutlet var litersTextField: UITextField!
    
    @IBOutlet var pintTextField: UITextField!
    @IBOutlet var fluidOunceTextField: UITextField!
    
    
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
        
        guard let gallons = self.gallonsTextField.text, !gallons.isEmpty else {
            
            return
        }
        guard let liters = self.litersTextField.text, !liters.isEmpty else {
            
            return
        }
        guard let pints = self.pintTextField.text, !pints.isEmpty else {
            
            return
        }
        guard let fluidOunce = self.fluidOunceTextField.text, !fluidOunce.isEmpty else {
            
            return
        }
        

        
        let history = gallons+" Gallons = "+liters+" Liters = "+pints+" Pints = "+fluidOunce+" Fluid Ounces"
        
        if UserDefaults.standard.object(forKey: "liquidHistory") != nil {
            
            var getHistories = defaults.array(forKey: "liquidHistory") as! [String]  //getting the current history array that has already been stored
            
            getHistories.append(history) // adding new history
            
            
            //adding one history from the head and removing the old one from the tail
            if getHistories.count > 5 {
                
                getHistories.remove(at: 0) // removing the old history
                
                
            }
            
            
            defaults.set(getHistories, forKey: "liquidHistory") // replacing old histories array with the new histories array
            
        } else {
            defaults.set([history], forKey: "liquidHistory")
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
            
            if sender == self.gallonsTextField {
                
                if let number = Double(sender.text!){
                    previousNumber = number
                    let goodUnit = UnitVolume.milliliters
                    let goodWeight:Measurement = Measurement(value: number, unit: goodUnit)
                    
                    
                    self.litersTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .liters).value))
                    
                    self.pintTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .pints).value))
                    
                    self.fluidOunceTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .fluidOunces).value))
                } else {
                    
                    print("error")
                    
                    
                    if previousNumber != nil {
                        sender.text = String(describing: previousNumber!)
                    }
                    
                }
            }
            
            
            if sender == self.litersTextField {
                if let number = Double(sender.text!){
                    previousNumber = number
                    let goodUnit = UnitVolume.liters
                    let goodWeight:Measurement = Measurement(value: number, unit: goodUnit)
                    
                    self.gallonsTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .gallons).value))

                    
                    self.pintTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .pints).value))
                    
                    self.fluidOunceTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .fluidOunces).value))
                } else {
                    
                    print("error")
                    
                    
                    if previousNumber != nil {
                        sender.text = String(describing: previousNumber!)
                    }
                    
                }
                
                
            }
            
            if sender == self.pintTextField {
                
                if let number = Double(sender.text!){
                    previousNumber = number
                    let goodUnit = UnitVolume.milliliters
                    let goodWeight:Measurement = Measurement(value: number, unit: goodUnit)
                    
                    self.gallonsTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .gallons).value))
                    
                    self.litersTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .liters).value))
 
                    
                    self.fluidOunceTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .fluidOunces).value))
                } else {
                    
                    print("error")
                    
                    
                    if previousNumber != nil {
                        sender.text = String(describing: previousNumber!)
                    }
                    
                }
            }
            
            if sender == self.fluidOunceTextField {
                
                if let number = Double(sender.text!){
                    previousNumber = number
                    let goodUnit = UnitVolume.milliliters
                    let goodWeight:Measurement = Measurement(value: number, unit: goodUnit)
                    
                    self.gallonsTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .gallons).value))
                    
                    self.litersTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .liters).value))
                    
                    self.pintTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .pints).value))

                } else {
                    
                    print("error")
                    
                    
                    if previousNumber != nil {
                        sender.text = String(describing: previousNumber!)
                    }
                    
                }
            }
        }  else {
            
            self.gallonsTextField.text = ""
            self.litersTextField.text = ""
            self.pintTextField.text = ""
            self.fluidOunceTextField.text = ""
            
            self.hideSaveButton()
            
            previousNumber = 0
            
        }
        
    }
    
    
    func roundToFourDecimalPlaces(double : Double) -> Double{
        return  (double * 10000).rounded()/10000
    }
    
    
}

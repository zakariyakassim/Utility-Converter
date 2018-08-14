//
//  ViewController.swift
//  Utility Converter
//
//  Created by ismail ali on 14/03/2018.
//  Copyright © 2018 Ismail Ali. All rights reserved.
//

import UIKit

class WeightViewController: UIViewController {
    
    @IBOutlet weak var kilogramsTextField: UITextField!
    @IBOutlet weak var gramsTextField: UITextField!
    @IBOutlet weak var ouncesTextField: UITextField!
    @IBOutlet weak var poundsTextField: UITextField!
    @IBOutlet weak var stonesTextField: UITextField!
    @IBOutlet weak var stonesPoundTextfield: UITextField!

    
    let defaults = UserDefaults.standard
    
    var keyBoardHeight:CGFloat = 0

    @IBOutlet var navigationBar: UINavigationBar!
    
    
    @IBOutlet weak var barBtnSave: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideSaveButton()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    func hideSaveButton(){ // this function hides the save button whenever its called
        self.barBtnSave.title = ""
        self.barBtnSave.isEnabled = false
    }
    
    func showSaveButton(){ // this function shows the save button whenever its called
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
 

    
    func stonesAndPounds(stonesRef : Double) -> (stones : Int, pounds : Double) { // this is a function that returns an Int and Double
        
        let splitPi = modf(stonesRef) // splits and seperates the whole number and decimal and returns array
        
        //if stonesRef = 5.67556
        //splitPi.0 = 5.0
        //splitPi.1 = 0.67556

        let goodUnit = UnitMass.stones
        let goodWeight:Measurement = Measurement(value: splitPi.1, unit: goodUnit)
        let pounds = goodWeight.converted(to: .pounds).value // converting the decimal (splitPi.1) to pounds
        
        return (Int(splitPi.0), pounds) // returning stones as integer and converted pounds as Double
    }
    
    @IBAction func textFieldDidEndEditing(_ sender: UITextField) {
        
        
    }
    
    func saveHistory(){ // saves conversion history when this functions is called
        
        //  var histories = [String]()
        self.view.endEditing(true)
        guard let kilogramsTextField = self.kilogramsTextField.text, !kilogramsTextField.isEmpty else {
            
            return
        }
        
        let history = self.kilogramsTextField.text!+" Kilograms = "+self.gramsTextField.text!+" Grams = "+self.ouncesTextField.text!+" Ounces = "+self.poundsTextField.text!+" Pounds = "+self.stonesTextField.text!+" Stones "+self.stonesPoundTextfield.text!+" Pounds"
        
        if UserDefaults.standard.object(forKey: "histories") != nil { // checking if userdefault histories already exist
            
            //if exist
            
            var getHistories = defaults.array(forKey: "histories") as! [String]  //getting the current history array that has already been stored
            
            getHistories.append(history) // adding new history
            
            
            //adding one history from the head and removing the old one from the tail
            if getHistories.count > 5 {

                getHistories.remove(at: 0) // removing the old history

                
            }
            
            
            defaults.set(getHistories, forKey: "histories") // replacing old histories array with the new histories array
            
        } else {
            // if it doesnt exist
            defaults.set([history], forKey: "histories") // creates new userdefault histories
        }
        
        defaults.synchronize()
    }
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        
        //when save button is pressed
        
        self.hideSaveButton() // hides button
        
        self.saveHistory() // saves history
        
        
        
    }
    
    func roundToFourDecimalPlaces(double : Double) -> Double{ //rounds a number to fourth decimal place
        return  (double * 10000).rounded()/10000
    }
    
    var previousNumber : Double!
    
    @IBAction func textFieldDidChange(_ sender: UITextField) { // this is called when any textfield is changed
        
        
        if sender.text != "" { // checks if the textfield is not empty
            
            //if textfield is not empty
            
            self.showSaveButton() //if textfields are not empty save button will be visible

            if sender == kilogramsTextField {
                
                if let number = Double(sender.text!) { //makes sure if the number from the textfield is a correct number
                
                previousNumber = number // setting it to previousNumber for backup
                    
                let goodUnit = UnitMass.kilograms
                let goodWeight:Measurement = Measurement(value: number, unit: goodUnit)
                
                self.gramsTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .grams).value)) // converting kilograms to grams and setting it to gramsTextfield and also rounding it to four decimal place
                self.ouncesTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .ounces).value))// converting kilograms to ounces and setting it to gramsTextfield also rounding it to four decimal place
                self.poundsTextField.text = String(describing: self.roundToFourDecimalPlaces(double: goodWeight.converted(to: .pounds).value))// converting kilograms to pounds and setting it to gramsTextfield also rounding it to four decimal place
                self.stonesTextField.text = String(describing: self.stonesAndPounds(stonesRef: goodWeight.converted(to: .stones).value).stones)// converting kilograms to stones and setting it to gramsTextfield also rounding it to four decimal place
                self.stonesPoundTextfield.text = String(describing: self.roundToFourDecimalPlaces(double: self.stonesAndPounds(stonesRef: goodWeight.converted(to: .stones).value).pounds))// converting kilograms to stones-pounds and setting it to gramsTextfield also rounding it to four decimal place
                
                } else {
                    //if number is not a correct double number
                    print("error")
                    
                    
                    if previousNumber != nil { //checks if previous number is not nil
                    sender.text = String(describing: previousNumber!) //then it replaces the current text to previous number
                    }

                }
                
            
            }
            
            
            if sender == gramsTextField {
                
                if let number = Double(sender.text!) { // it makes sure that it gets a correct double
                    
                    previousNumber = number
                
                let goodUnit = UnitMass.grams
                let goodWeight:Measurement = Measurement(value: number, unit: goodUnit)
                
                self.kilogramsTextField.text = String(describing: goodWeight.converted(to: .kilograms).value)
                self.ouncesTextField.text = String(describing: round(goodWeight.converted(to: .ounces).value))
                self.poundsTextField.text = String(describing: goodWeight.converted(to: .pounds).value)
                
                self.stonesTextField.text = String(describing: self.stonesAndPounds(stonesRef: goodWeight.converted(to: .stones).value).stones)
                self.stonesPoundTextfield.text = String(describing: self.stonesAndPounds(stonesRef: goodWeight.converted(to: .stones).value).pounds)
                    
                 
                
                } else {
                    
                    print("error")
                    
                    
                    if previousNumber != nil {
                        sender.text = String(describing: previousNumber!)
                    }
                    
                }
            }
            
            
            if sender == ouncesTextField {
                
                if let number = Double(sender.text!) {
                    
                    previousNumber = number
                
                let goodUnit = UnitMass.ounces
                let goodWeight:Measurement = Measurement(value: number, unit: goodUnit)
                
                self.kilogramsTextField.text = String(describing: goodWeight.converted(to: .kilograms).value)
                self.gramsTextField.text = String(describing: goodWeight.converted(to: .grams).value)
                self.poundsTextField.text = String(describing: goodWeight.converted(to: .pounds).value)
                
                self.stonesTextField.text = String(describing: self.stonesAndPounds(stonesRef: goodWeight.converted(to: .stones).value).stones)// it reads what
                self.stonesPoundTextfield.text = String(describing: self.stonesAndPounds(stonesRef: goodWeight.converted(to: .stones).value).pounds)
                
                } else {
                    
                    print("error")
                    
                    
                    if previousNumber != nil {
                        sender.text = String(describing: previousNumber!)
                    }
                    
                }
            }
            
            if sender == poundsTextField {
                
                if let number = Double(sender.text!) {
                    
                    previousNumber = number
                
                let goodUnit = UnitMass.pounds
                let goodWeight:Measurement = Measurement(value: number, unit: goodUnit)
                
                self.kilogramsTextField.text = String(describing: goodWeight.converted(to: .kilograms).value)
                self.gramsTextField.text = String(describing: goodWeight.converted(to: .grams).value)
                self.ouncesTextField.text = String(describing: goodWeight.converted(to: .ounces).value)
                
                self.stonesTextField.text = String(describing: self.stonesAndPounds(stonesRef: goodWeight.converted(to: .stones).value).stones)
                self.stonesPoundTextfield.text = String(describing: self.stonesAndPounds(stonesRef: goodWeight.converted(to: .stones).value).pounds)
                } else {
                    
                    print("error")
                    
                    
                    if previousNumber != nil {
                        sender.text = String(describing: previousNumber!)
                    }
                    
                }
            }
            
            
        } else {
            
            self.kilogramsTextField.text = ""
            self.gramsTextField.text = ""
            self.ouncesTextField.text = ""
            self.poundsTextField.text = ""
            self.stonesTextField.text = ""
            self.stonesPoundTextfield.text = ""
            
            self.hideSaveButton() //hides save button because theres nothing to save to history
            
            previousNumber = 0
            
        }
        
        
        
        
        
        
    }
    
    
}


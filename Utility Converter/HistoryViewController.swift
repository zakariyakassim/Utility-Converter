//
//  HistoryViewController.swift
//  Utility Converter
//
//  Created by ismail ali on 17/03/2018.
//  Copyright © 2018 Ismail Ali. All rights reserved.
//

import UIKit

class HistoryViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    var histories = [String]()
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.title = "History"
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.histories = defaults.array(forKey: "histories") as! [String] //reading history as array of strings and setting to histories
        self.tableView.reloadData() // reloading tableview data
    }
    
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            if UserDefaults.standard.object(forKey: "histories") != nil {
                self.histories = defaults.array(forKey: "histories") as! [String]
                
                self.tableView.reloadData()
            } else {
                self.histories.removeAll()
            }
            self.tableView.reloadData()
            
        case 1:
            if UserDefaults.standard.object(forKey: "temperatureHistory") != nil { //checking if temperature history is not nil
                
                //if not nil
                self.histories = defaults.array(forKey: "temperatureHistory") as! [String] // getting the temperatureHistory as array of strings and setting it to histories
                
                self.tableView.reloadData() // then reloads the tableview
            } else {
                self.histories.removeAll()
            }
            self.tableView.reloadData()
            
        case 2:
            if UserDefaults.standard.object(forKey: "speedHistory") != nil {
                self.histories = defaults.array(forKey: "speedHistory") as! [String]
                
                self.tableView.reloadData()
            } else {
                self.histories.removeAll()
            }
            self.tableView.reloadData()
            
        case 3:
            if UserDefaults.standard.object(forKey: "liquidHistory") != nil {
                self.histories = defaults.array(forKey: "liquidHistory") as! [String]

            } else {
                self.histories.removeAll()
            }
            self.tableView.reloadData()

        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.text = self.histories[indexPath.row]
        
        return cell
    }
}

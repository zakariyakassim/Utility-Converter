//
//  MoreViewController.swift
//  Utility Converter
//
//  Created by ismail ali on 18/03/2018.
//  Copyright © 2018 Ismail Ali. All rights reserved.
//

import UIKit

class MoreViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let moreMenu : [String] = ["Constants","History"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.navigationItem.title = "More"
        self.tableView.tableFooterView = UIView()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath) as! CustomCell
        
        cell.label.text = self.moreMenu[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConstantsViewController") as! ConstantsViewController
            
            self.show(vc, sender: nil)
        }
        
        if indexPath.row == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            
            self.show(vc, sender: nil)
        }
        
        
    }
    
    
}

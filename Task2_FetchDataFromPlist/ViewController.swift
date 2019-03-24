//
//  ViewController.swift
//  Task2_FetchDataFromPlist
//
//  Created by MOSHIOUR on 1/27/19.
//  Copyright © 2019 moshiour. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate let cellId = "cell"
    var tableData = [ListItem]()
    var dataArray = [String]()
    private var finishedLoadingInitialTableCells = false
    @IBOutlet weak var tableView: UITableView!
    
    
    required init?(coder aDecoder: NSCoder) {
        
        tableData = [ListItem]()
        
        super.init(coder: aDecoder)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        
        let path = Bundle.main.path(forResource: "data", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        dataArray = dict!.object(forKey: "dataItem") as! [String]

        for count in 0..<dataArray.count{
            print(dataArray[count])
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell
        let item = tableData[indexPath.row]
        //configureText(for: cell, with: item)
        //cell.textLabel?.text = item.text
        //cell.textLabel?.numberOfLines = 0
        
        cell.messageLabel.text = item.text
        
        cell.isIncoming = indexPath.row % 2 == 0

        
        return cell
        
    }
    @IBAction func addButtonPress(_ sender: Any) {
        
        let newRowIndex = tableData.count
        
        if(newRowIndex < dataArray.count){
        
        let item = ListItem()
        
        let title = dataArray[Int(newRowIndex)]
        print(title)
        item.text = title
        tableData.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var lastInitialDisplayableCell = false
        
        //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
        if tableData.count > 0 && !finishedLoadingInitialTableCells {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplayableCell = false
            }
        }
        
        if !finishedLoadingInitialTableCells {
            
            if lastInitialDisplayableCell {
                finishedLoadingInitialTableCells = true
            }
            
            //animates the cell as it is being displayed for the first time
            cell.transform = CGAffineTransform(translationX: 0, y: 20)
            cell.alpha = 0
            
            UIView.animate(withDuration: 1.2, delay: 0.05*Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
        }
    }
    
}




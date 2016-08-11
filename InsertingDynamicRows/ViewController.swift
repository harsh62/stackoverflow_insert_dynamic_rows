//
//  ViewController.swift
//  InsertingDynamicRows
//
//  Created by Harsh Singh on 2016-08-10.
//  Copyright © 2016 Harsh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    var names = ["Steve", "Bill", "Linus", "Bret"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        names += ["Test"]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "Row Number : \(indexPath.row) with name\(names[indexPath.row])"
        
        return cell!
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = CGFloat(offset.y + bounds.size.height - inset.bottom)
        let h = CGFloat(size.height)
        
        let reload_distance = CGFloat(-100)
        
        if (y > (h + reload_distance)) {
            insertRows()
        }
    }
    
    func insertRows() {
        let newData = ["Steve", "Bill", "Linus", "Bret"]
        let olderCount: Int = self.names.count
        
        names += newData
        
        var indexPaths = [NSIndexPath]()
        for i in 0..<newData.count {//hardcoded 20, this should be the number of new results received
            indexPaths.append(NSIndexPath(forRow: olderCount + i, inSection: 0))
        }
        // tell the table view to update (at all of the inserted index paths)
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Top)
        self.tableView.endUpdates()
    }
    
    func dataFromServer() {
        let url = NSURL(string: "http://www.json-generator.com/api/json/get/coDxrSkrNe?indent=2")!
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    if let restaurants = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [[String:AnyObject]] {
                        
                        
                        
                        let names = restaurants.flatMap { $0["preferred_name"] as? String }
                        
                        
                        for restaurant in restaurants {
                            if let name = restaurant["preferred_name"] as? String {
                                self.names.append(name)
                            }
                        }
                        
                        
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                            
                        }
                        
                        print(names)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            }.resume()
        
        self.tableView.reloadData()
    }

    @IBAction func refresh(sender: AnyObject) {
        dataFromServer()
    }
    
    var selectedIndexPaths = [NSIndexPath]()
    
    func fetchOlderIndexPaths() {
        NSLog(@"***************Selected Ingredients**************** %@", self.selectedIngredients);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.lastIndexPath = [defaults objectForKey:@"lastIndexPathUsed"];
    }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }

}


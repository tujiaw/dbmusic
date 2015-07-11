//
//  LoveListViewController.swift
//  dbmusic
//
//  Created by tutujiaw on 15/7/11.
//  Copyright (c) 2015年 tujiaw. All rights reserved.
//

import UIKit

class LoveListViewController: UIViewController {
    
    let cellId = "loveSongCell"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoveSongModel.count()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        cell?.textLabel?.text = LoveSongModel.getObject(indexPath.row, key: "title")
        return cell!
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
       if editingStyle == UITableViewCellEditingStyle.Delete {
        LoveSongModel.remove(LoveSongModel.getObject(indexPath.row, key: "ssid")!)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

}

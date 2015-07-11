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
    var loveDic: [String: AnyObject]?
    
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
        let userData = NSUserDefaults.standardUserDefaults()
        let data = userData.persistentDomainForName("loveSongList")
        loveDic = data as? [String: AnyObject]
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dic = loveDic {
            println(dic.count)
            return dic.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
        var json = JSON((loveDic?.values.array[indexPath.row])!)
        cell?.textLabel?.text = json["title"].string
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

}

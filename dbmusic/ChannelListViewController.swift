//
//  ChannelListViewController.swift
//  dbmusic
//
//  Created by tutujiaw on 15/7/4.
//  Copyright (c) 2015年 tujiaw. All rights reserved.
//

import UIKit

class ChannelListViewController: UIViewController {

    @IBOutlet weak var channelTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SongChannelModel.instance.requestAllChannel() {
            self.channelTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SongChannelModel.instance.channelData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let channelCell = "channelCell"
        let cell = self.channelTableView.dequeueReusableCellWithIdentifier(channelCell) as! UITableViewCell
        cell.textLabel?.text = SongChannelModel.instance.channelData[indexPath.row]["name"].string
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var channelId = SongChannelModel.instance.channelData[indexPath.row]["channel_id"].stringValue.toInt()
        if let id = channelId {
            SongChannelModel.instance.currentChannel = id
        }
        self.tabBarController?.selectedIndex = 0
    }
}

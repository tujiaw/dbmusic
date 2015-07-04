//
//  ViewController.swift
//  dbmusic
//
//  Created by tutujiaw on 15/7/3.
//  Copyright (c) 2015年 tujiaw. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RoundRotateViewDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var channelTableView: UITableView!
    @IBOutlet weak var playView: RoundRotateView!
    
    let songPlayer = MPMoviePlayerController()
    let refreshControl = UIRefreshControl()
    var oldChannel: Int = SongChannelModel.instance.currentChannel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.playView.delegate = self
        self.playView.roundImage = UIImage(named: "girl")
        self.playView.isPlay = false
        
        let blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        backgroundImage.addSubview(blurView)
        
        SongChannelModel.instance.requestSong(fromChannel: SongChannelModel.instance.currentChannel) {
            self.channelTableView.reloadData()
        }
        
        refreshControl.addTarget(self, action: "downDragRefresh", forControlEvents: .ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        channelTableView.addSubview(refreshControl)
        
        // 监听播放结束
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onPlayFinished", name: MPMoviePlayerPlaybackDidFinishNotification, object: songPlayer)
    }
    
    override func viewDidAppear(animated: Bool) {
        if oldChannel != SongChannelModel.instance.currentChannel {
            oldChannel = SongChannelModel.instance.currentChannel
            SongChannelModel.instance.requestSong(fromChannel: SongChannelModel.instance.currentChannel) {
                self.channelTableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SongChannelModel.instance.songData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("channels") as? UITableViewCell
        cell?.backgroundColor = UIColor.clearColor()
        cell?.textLabel?.text = SongChannelModel.instance.songData[indexPath.row]["title"].string
        cell?.detailTextLabel?.text = SongChannelModel.instance.songData[indexPath.row]["artist"].string
        SongChannelModel.instance.getImage(indexPath.row, resultHandle: {
            (image) -> Void in cell?.imageView?.image = image
        })
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SongChannelModel.instance.getImage(indexPath.row, resultHandle: {
            (image) -> Void in
            self.backgroundImage.image = image
            self.playView.roundImage = image
        })
        self.navigationItem.title = SongChannelModel.instance.songData[indexPath.row]["title"].string
        self.playView.isPlay = true
        playStateChanged(self.playView.isPlay)
    }
    
    func downDragRefresh() {
        SongChannelModel.instance.requestSongCurrentChannel() {
            self.channelTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func playStateChanged(isPlay: Bool) {
        let indexPath = self.channelTableView.indexPathForSelectedRow()
        if let indexPath = indexPath {
            if isPlay {
                let url = SongChannelModel.instance.songData[indexPath.row]["url"].string
                if let url = url {
                    self.songPlayer.contentURL = NSURL(string: url)
                    self.songPlayer.play()
                    return
                }
            }
        }
        self.songPlayer.pause()
    }
    
    func onPlayFinished() {

    }
    
    //////////////////////////////////////////////////////////
}


//
//  ViewController.swift
//  dbmusic
//
//  Created by tutujiaw on 15/7/3.
//  Copyright (c) 2015年 tujiaw. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
        RoundRotateViewDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var songTableView: UITableView!
    @IBOutlet weak var playView: RoundRotateView!
    @IBOutlet weak var lyricView: LyricView!
    
    let songPlayer = MPMoviePlayerController()
    let refreshControl = UIRefreshControl()
    var oldChannel: Int = SongChannelModel.instance.currentChannel
    var currentIndexPath: NSIndexPath?
    var timer: NSTimer?
    
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
            self.songTableView.reloadData()
        }
        
        refreshControl.addTarget(self, action: "downDragRefresh", forControlEvents: .ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        songTableView.addSubview(refreshControl)
        
        // 监听播放结束
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onPlayFinished", name: MPMoviePlayerPlaybackDidFinishNotification, object: songPlayer)
    }
    
    override func viewDidAppear(animated: Bool) {
        if oldChannel != SongChannelModel.instance.currentChannel {
            oldChannel = SongChannelModel.instance.currentChannel
            SongChannelModel.instance.requestSongCurrentChannel() {
                print(SongChannelModel.instance.songData.count)
                self.songTableView.reloadData()
            }
        }
        self.songTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SongChannelModel.instance.songData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(SongTableViewCell.id) as? SongTableViewCell
        if cell == nil {
            cell = SongTableViewCell(style: .Subtitle, reuseIdentifier: SongTableViewCell.id)
        }
        cell?.indexPath = indexPath
        SongChannelModel.instance.getImage(indexPath.row, resultHandle: {
            (image) ->Void in cell?.imageView?.image = image
        })
        cell?.titleLabel?.text = SongChannelModel.instance.songData[indexPath.row]["title"].string
        cell?.contentLabel?.text = SongChannelModel.instance.songData[indexPath.row]["artist"].string
        if LoveSongModel.exist(SongChannelModel.instance.songData[indexPath.row]["ssid"].string!) {
            cell?.loveButton?.setTitle("", forState: .Normal)
        } else {
            cell?.loveButton?.setTitle("❤️", forState: .Normal)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        playMusic(indexPath.row)
    }
    
    func downDragRefresh() {
        SongChannelModel.instance.requestSongCurrentChannel() {
            self.songTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func playMusic(row: Int) {
        SongChannelModel.instance.getImage(row, resultHandle: {
            (image) -> Void in
            self.backgroundImage.image = image
            self.playView.roundImage = image
        })
        self.navigationItem.title = SongChannelModel.instance.songData[row]["title"].string
        self.playView.isPlay = true
        playStateChanged(self.playView.isPlay)
    }
    
    func playStateChanged(isPlay: Bool) {
        currentIndexPath = self.songTableView.indexPathForSelectedRow()
        if let indexPath = currentIndexPath {
            if isPlay {
                let url = SongChannelModel.instance.songData[indexPath.row]["url"].string
                if let url = url {
                    self.songPlayer.contentURL = NSURL(string: url)
                    self.songPlayer.play()
                    let title = SongChannelModel.instance.songData[indexPath.row]["title"].string
                    let artist = SongChannelModel.instance.songData[indexPath.row]["artist"].string
                    LyricManager.instance.cacheLyc(title!, artist: artist!)
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "onTimer", userInfo: nil, repeats: true)
                    return
                }
            }
        }
        timer?.invalidate()
        self.songPlayer.pause()
    }
    
    func onPlayFinished() {
        if let indexPath = currentIndexPath {
            var row = indexPath.row + 1
            if row >= SongChannelModel.instance.songData.count {
                row = 0
            }
            self.songTableView.selectRowAtIndexPath(NSIndexPath(forRow: row, inSection: currentIndexPath!.section), animated: true, scrollPosition: .Top)
            playMusic(row)
        }
    }
    
    func onTimer() {
        if self.songPlayer.duration >= 0 && self.songPlayer.currentPlaybackTime >= 0 {
            let currentTime = LyricTime(second: Int(self.songPlayer.currentPlaybackTime))
            let totalTime = LyricTime(second: Int(self.songPlayer.duration))
            self.lyricView.setProgress(currentTime, totalTime: totalTime)
        }
    }
    //////////////////////////////////////////////////////////
}


//
//  SongChannelModel.swift
//  dbmusic
//
//  Created by tutujiaw on 15/7/4.
//  Copyright (c) 2015年 tujiaw. All rights reserved.
//

import UIKit

class SongChannelModel: NSObject {
    static var s_instance = SongChannelModel()
    class var instance: SongChannelModel {
        return s_instance
    }
    
    var currentChannel = 0
    var pictureCache: [String: UIImage] = [:]
    var channelData: [JSON] = []
    var songData: [JSON] = []
    
    func requestAllChannel(resultHandle: () -> Void) {
        Alamofire.manager.request(Method.GET, "http://www.douban.com/j/app/radio/channels").responseJSON(options: NSJSONReadingOptions.MutableContainers, completionHandler: {
            (_, _, data, error) in
            if let data:AnyObject = data {
                self.onChannelResult(data)
                resultHandle()
            }
        })
    }
    
    func requestSong(fromChannel channel: Int, resultHandle: () -> Void) {
        //print("http://douban.fm/j/mine/playlist?channel=\(channel)")
        //print("http://douban.fm/j/mine/playlist?type=n&channel=\(channel)&from=mainsite")
        let url = "http://www.douban.com/j/app/radio/people?app_name=radio_desktop_win&version=100&type=n&channel=\(channel)"
        println(url)
        Alamofire.manager.request(Method.GET, url).responseJSON(options: NSJSONReadingOptions.MutableContainers, completionHandler: {
            (_, _, data, error) in
            if let data:AnyObject = data {
                self.onSongResult(data)
                resultHandle()
            }
        })
    }
    
    func requestSongCurrentChannel(resultHandle: () -> Void) {
        self.requestSong(fromChannel: self.currentChannel, resultHandle: resultHandle)
    }
    
    func getImage(row: Int, resultHandle: (image: UIImage) -> Void) {
        var url = self.songData[row]["picture"].string
        if url == nil {
            resultHandle(image: UIImage(named: "thumb")!)
            return
        }
        
        let image = self.pictureCache[url!] as UIImage?
        if let image = image {
            resultHandle(image: image)
        } else {
            resultHandle(image: UIImage(named: "thumb")!)
            Alamofire.manager.request(Method.GET, url!).response({
                (_, _, data, error) -> Void in
                var newImage = UIImage(data: data! as! NSData)
                if let newImage = newImage {
                    self.pictureCache[url!] = newImage
                    resultHandle(image: newImage)
                }
            })
        }
    }
    
    func onChannelResult(data: AnyObject) {
        let json = JSON(data)
        if let channels = json["channels"].array {
            channelData = channels
        }
    }
    
    func onSongResult(data: AnyObject) {
        let json = JSON(data)
        if let song = json["song"].array {
            self.songData = song
        }
    }
    
}

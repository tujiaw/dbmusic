//
//  SongTableViewCell.swift
//  dbmusic
//
//  Created by tutujiaw on 15/7/11.
//  Copyright (c) 2015年 tujiaw. All rights reserved.
//

import UIKit

protocol SongTableViewCellDelegate {
    func onLove(indexPath: NSIndexPath?)
}

class SongTableViewCell: UITableViewCell {

    class var id: String {
        return "songCellId"
    }
    
    var delegate: SongTableViewCellDelegate?
    var indexPath: NSIndexPath?
    
    var headView: UIImageView?
    var titleLabel: UILabel?
    var contentLabel: UILabel?
    var loveButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var rect = self.frame
        var headRect = CGRect(x: 0, y: 0, width: rect.height, height: rect.height)
        var loveRect = CGRect(x: rect.width - rect.height - 5, y: 0, width: rect.height, height: rect.height)
        var titleRect = CGRect(x: headRect.width + 20, y: 3, width: 200, height: rect.height / 2)
        var contentRect = CGRect(x: headRect.width + 20, y: titleRect.height, width: 200, height: rect.height / 2)
        
        headView = UIImageView(frame: headRect)
        titleLabel = UILabel(frame: titleRect)
        contentLabel = UILabel(frame: contentRect)
        loveButton = UIButton(frame: loveRect)
        
        titleLabel?.font = UIFont(name: "Helvetica", size: 14)
        contentLabel?.font = UIFont(name: "Helvetica", size: 11)
        
        self.addSubview(headView!)
        self.addSubview(titleLabel!)
        self.addSubview(contentLabel!)
        self.addSubview(loveButton!)
        
        loveButton?.addTarget(self, action: "onLove", forControlEvents: .TouchUpInside)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onLove() {
        if let row = self.indexPath?.row {
            var ssid = SongChannelModel.instance.songData[row]["ssid"].string
            if let ssid = ssid {
                LoveSongModel.updateValue(SongChannelModel.instance.songData[row].object, fromKey: ssid)
                loveButton?.setTitle("", forState: .Normal)
            }
        }
    }
}

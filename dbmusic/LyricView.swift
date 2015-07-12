//
//  LyricView.swift
//  myview
//
//  Created by tutujiaw on 15/7/5.
//  Copyright (c) 2015年 tujiaw. All rights reserved.
//

import UIKit

struct LyricTime {
    var minute: Int {
        return self.totalSecond / 60
    }
    
    var second: Int {
        return self.totalSecond % 60
    }
    
    var totalSecond: Int = 0
    
    init(second: Int) {
        self.totalSecond = second
    }
    
    var str: String {
        return NSString(format: "%02d:%02d", self.minute, self.second) as String
    }
}

class LyricView: UIView {
    
    var label: UILabel?
    var backgroundLabel: UILabel?
    
//    var totalTime = LyricTime()
//    var currentTime = LyricTime() {
//        didSet {
//            if self.currentTime.totalSecond < self.totalTime.totalSecond {
//                self.label?.frame.size.width = self.frame.width * (CGFloat(currentTime.totalSecond) / CGFloat(totalTime.totalSecond))
//                var content = LyricManager.instance.current?.getContent(minute: currentTime.minute, second: currentTime.second)
//                if let content = content {
//                    self.backgroundLabel!.text = content
//                }
//            } else {
//                self.backgroundLabel?.text = ""
//            }
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView() {
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: self.frame.height))
        self.label?.backgroundColor = UIColor.lightGrayColor()
        
        self.backgroundLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.backgroundLabel?.backgroundColor = UIColor.clearColor()
        self.backgroundLabel?.textAlignment = NSTextAlignment.Center
        
        self.addSubview(self.label!)
        self.addSubview(self.backgroundLabel!)
    }
    
    func setProgress(currentTime: LyricTime, totalTime: LyricTime) {
        if currentTime.totalSecond < totalTime.totalSecond {
            self.label?.frame.size.width = self.frame.width * (CGFloat(currentTime.totalSecond) / CGFloat(totalTime.totalSecond))
            var content = LyricManager.instance.current?.getContent(minute: currentTime.minute, second: currentTime.second)
            if let content = content {
                self.backgroundLabel?.text = content
            }
        } else {
            self.backgroundLabel?.text = ""
        }
    }
}

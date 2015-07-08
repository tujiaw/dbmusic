//
//  RoundRotateView.swift
//  RoundRotateView
//
//  Created by tutujiaw on 15/7/4.
//  Copyright (c) 2015年 tujiaw. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics


protocol RoundRotateViewDelegate {
    func playStateChanged(isPlay: Bool)
}

class RoundRotateView: UIView {

    var delegate: RoundRotateViewDelegate?
    let rotationDuration: CFTimeInterval = 8
    var roundImageView: UIImageView!
    var playStateButton: UIButton!
    
    var isPlay: Bool = false {
        willSet {
            if newValue {
                if !self.isPlay {
                    startRotation()
                }
            } else {
                stopRotation()
            }
        }
//        didSet {
//            if self.isPlay {
//                startRotation()
//            } else {
//                stopRotation()
//            }
//        }
    }
    
    var roundImage: UIImage! {
        didSet {
            self.roundImageView.image = self.roundImage
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView() {
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        
        self.layer.cornerRadius = center.x
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1.0
        
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSizeMake(0, 1)
        
        self.roundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.roundImageView.center = center
        self.roundImageView.image = self.roundImage
        self.addSubview(self.roundImageView)
        
        var stateImage = UIImage(named: self.isPlay ? "start" : "pause")
        self.playStateButton = UIButton(frame: CGRect(x: 0, y: 0, width: stateImage!.size.width, height: stateImage!.size.height))
        self.playStateButton.addTarget(self, action: "playStateChanged", forControlEvents: UIControlEvents.TouchUpInside)
        self.playStateButton.setImage(stateImage, forState: UIControlState.Normal)
        self.playStateButton.center = center
        self.addSubview(self.playStateButton)
    }
    
    func playStateChanged() {
        self.isPlay = !self.isPlay
        self.delegate?.playStateChanged(self.isPlay)
    }
    
    func rotation() {
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveLinear, animations: {
            self.roundImageView.transform = CGAffineTransformRotate(self.roundImageView.transform, CGFloat(M_PI/20))
            }, completion: {
                (finished) -> Void in
                if self.isPlay {
                    self.rotation()
                }
        })
    }
    
    func startRotation() {
        self.playStateButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
        rotation()
    }
    
    func stopRotation() {
        self.playStateButton.setImage(UIImage(named: "start"), forState: UIControlState.Normal)
        //self.userInteractionEnabled = false
    }
}

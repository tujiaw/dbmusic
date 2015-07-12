//
//  LoveSongModel.swift
//  dbmusic
//
//  Created by tutujiaw on 15/7/11.
//  Copyright (c) 2015年 tujiaw. All rights reserved.
//

import UIKit

class LoveSongModel: NSObject {
    static let loveSongList = "loveSongList"
    
    class func updateValue(object: AnyObject, fromKey key: String) {
        let userData = NSUserDefaults.standardUserDefaults()
        var loveList = userData.persistentDomainForName(loveSongList)
        if loveList == nil {
            loveList = [key: object]
        } else {
            loveList?.updateValue(object, forKey: key)
        }
        userData.setPersistentDomain(loveList!, forName: loveSongList)
    }
    
    class func exist(key: String) -> Bool {
        let userData = NSUserDefaults.standardUserDefaults()
        var loveList = userData.persistentDomainForName(loveSongList)
        return loveList?.indexForKey(key) != nil
    }
    
    class func remove(key: String) {
        let userData = NSUserDefaults.standardUserDefaults()
        var loveList = userData.persistentDomainForName(loveSongList)
        loveList?.removeValueForKey(key)
        userData.setPersistentDomain(loveList!, forName: loveSongList)
    }
    
    class func getObject(fromKey key: String) -> AnyObject? {
        let userData = NSUserDefaults.standardUserDefaults()
        var loveList = userData.persistentDomainForName(loveSongList)
        if loveList?.indexForKey(key) != nil {
            let data = loveList as! [String: AnyObject]
            return data[key]
        }
        return nil
    }
    
    class func getObject(fromRow row: Int) -> AnyObject? {
        let userData = NSUserDefaults.standardUserDefaults()
        var loveList = userData.persistentDomainForName(loveSongList)
        return loveList?.values.array[row]
    }
    
    class func getValue(row: Int, key: String) -> String? {
        var anyObject: AnyObject? = getObject(fromRow: row)
        if let anyObject: AnyObject = anyObject {
            var json = JSON(anyObject)
            return json[key].string
        }
        return nil
    }
    
    class func count() -> Int {
        let userData = NSUserDefaults.standardUserDefaults()
        var loveList = userData.persistentDomainForName(loveSongList)
        if let loveList = loveList {
            return loveList.count
        }
        return 0
    }
}

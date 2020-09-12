/*
    Copyright (C) 2017 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A struct used throughout the sample to represent example data.
*/

import Foundation
import SwiftyJSON

struct CellDataItem: Codable, Equatable {
    var cid:String
    var bvid:String
    var pic: String
    var title :String
    var aid :String
    var videoDetail: VideoDetail
    
    init(jsonData:JSON) {
        self.cid = jsonData["cid"].stringValue
        self.bvid = jsonData["bvid"].stringValue
        self.pic = jsonData["pic"].stringValue
        self.aid = jsonData["aid"].stringValue
        self.title = jsonData["title"].stringValue
        self.videoDetail = VideoDetail(jsonData: jsonData)
    }
}

struct VideoDetail: Codable {
    var videos:Int
    var owner:Owner
    var tid :String
    var ctime:String
    var duration:String
    var desc:String
    var pubdate:String
    var state:Int
    var attribute:String
    var tname:String
    var copyright:Int
    var dynamic:String
    
    init(jsonData:JSON) {
        self.videos = jsonData["videos"].int ?? -1
        self.owner = Owner(jsonData: jsonData["owner"])
        self.tid = jsonData["tid"].stringValue
        self.ctime = jsonData["ctime"].stringValue
        self.duration = jsonData["duration"].stringValue
        self.desc = jsonData["desc"].stringValue
        self.pubdate = jsonData["pubdate"].stringValue
        self.state = jsonData["state"].int ?? -1
        self.attribute = jsonData["attribute"].stringValue
        self.tname = jsonData["tname"].stringValue
        self.copyright = jsonData["copyright"].int ?? -1
        self.dynamic = jsonData["dynamic"].stringValue
    }
}

struct OfficialVerify: Codable {
    var role :Int
    var title :String
    var desc :String
    
    init(jsonData:JSON) {
        self.role = jsonData["role"].int ?? -1
        self.title = jsonData["title"].stringValue
        self.desc = jsonData["desc"].stringValue
    }
}

struct Owner : Codable{
    var mid:String
    var name:String
    var face:String
    
    init(jsonData:JSON) {
        self.mid = jsonData["mid"].stringValue
        self.name = jsonData["name"].stringValue
        self.face = jsonData["face"].stringValue
    }
}

// MARK: Equatable

func ==(lhs: CellDataItem, rhs: CellDataItem)-> Bool {
    // Two `DataItem`s are considered equal if their identifiers and titles match.
    return lhs.aid == rhs.aid && lhs.bvid == rhs.bvid
}

//
//  PlayInfo.swift
//  Alibili
//
//  Created by Xiaonan Zhang on 2019/07/13.
//  Copyright © 2019 Xiaonan Zhang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PlayInfo : Decodable {
    
    let code:Int
    let message:String
    let ttl:Int
    let data:PlayInfoData
    let session:String
//    let videoFrame:JSON
    
//    init(from decoder: Decoder) throws {
////        let container = try decoder.container(keyedBy: CodingKeys.self)
////        status = try container.decode(String.self, forKey: .status)
////        let dataString = try container.decode(String.self, forKey: .data)
////        person = try JSONDecoder().decode(Person.self, from: Data(dataString.utf8))
//    }
}

struct PlayInfoData : Decodable {
    let from:String
    let result:String
    let message:String
    let quality:Int
    let format:String
    let timelength:String
    let accept_format:String
    let accept_description:[String]
    let accept_quality:[String]
    let video_codecid:Int
    let seek_param:String
    let seek_type:String
    let dash:Dash
}

struct Dash: Decodable {
    let duration:Int
    let minBufferTime:Float
    let min_buffer_time:Float
    let video:[Video]
//    let audio:[Audio]
}

struct Video :Decodable{
    let id:Int
    let baseUrl:String
    let base_url:String
    let backupUrl:String
    let backup_url:String
    let bandwidth:String
    let mimeType:String
    let mime_type:String
    let codecs:String
    let width:Int
    let height:Int
    let frameRate:String
    let frame_rate:String
    let sar:String
    let startWithSap:Int
    let start_with_sap:Int
    let SegmentBase:SegmentBase
    let segment_base:Segment_Base
    let codecid:Int
}

struct SegmentBase :Decodable{
    let Initialization:String
    let indexRange:String
}
struct Segment_Base :Decodable{
    let initialization:String
    let index_range:String
}

struct Audio :Decodable{
    
}

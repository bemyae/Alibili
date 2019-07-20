//
//  DanmuData.swift
//  Alibili
//
//  Created by Xiaonan Zhang on 2019/07/20.
//  Copyright © 2019 Xiaonan Zhang. All rights reserved.
//

import Foundation
import SWXMLHash

struct DanmuData : Codable{
    var timing:CUnsignedLongLong
    var mode:Int
    var fontSize:Int
    var color:String
    var timeStamp:String
    var pool:Int
    var text:String
    
//    ["141.41100", "1", "25", "16777215", "1563579915", "0", "7399117b", "19103870048796672"]
//    好厉害
    
    init(elem: XMLIndexer) {
        self.text = elem.element!.text
        var attr:[String] = []
        if let p:String = elem.value(ofAttribute: "p") {
            attr = p.components(separatedBy: ",")
        }
        self.timing = CUnsignedLongLong(floor(Double(attr[0])!))
        self.mode = Int(attr[1])!
        self.fontSize = Int(attr[2])!
        self.color = attr[3]
//        print(String(16777215, radix: 16))
        self.timeStamp = attr[4]
        self.pool = Int(attr[5])!
    }
}

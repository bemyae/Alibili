//
//  Urls.swift
//  Alibili
//
//  Created by xnzhang on 2020/09/09.
//  Copyright © 2020 Xiaonan Zhang. All rights reserved.
//

import Foundation

struct Urls {
    static let getLoginUrl: String = "https://passport.bilibili.com/qrcode/getLoginUrl"
    static let getLoginInfo: String = "https://passport.bilibili.com/qrcode/getLoginInfo"
    static let goUrl: String = "https://www.bilibili.com/"
    static let getTopPageRecomendation = "https://www.bilibili.com/index/ding.json"
    static let getUserInfo: String = "https://api.live.bilibili.com/User/getUserInfo"
    static func getSubscription(recentPerPage: Int, currentPage: Int) -> String{
        return "https://api.bilibili.com/x/web-feed/feed?ps=\(recentPerPage)&pn=\(currentPage)"
    }
    static func getHistory(recentPerPage: Int, currentPage: Int) -> String{
        return "https://api.bilibili.com/x/v2/history?pn=\(currentPage)&\(recentPerPage)&jsonp=jsonp"
    }
    static func getVideo(avId: String, pageNum: String) -> String{
        return "https://www.bilibili.com/video/av\(avId)/?p=\(pageNum)"
    }
    
    static func getDanmu(cid: String) -> String{
        return "https://api.bilibili.com/x/v1/dm/list.so?oid=\(cid)"
    }
    
    static func getVideoData(avId: String, cid: String) -> String{
        return "https://api.bilibili.com/x/player/playurl?avid=\(avId)&cid=\(cid)&qn=80&type=&fnver=0&fnval=16&otype=json"
    }
    
    static func getHttpReferrer(avId: String) -> String{
        return "https://www.bilibili.com/video/av\(avId)"
    }
    
    static func getVideoInfo(avId: String) -> String{
        return "https://api.bilibili.com/x/web-interface/view?aid=\(avId)"
    }
    
    static func getRelatedVideoInfo(avId: String) -> String{
        return "https://api.bilibili.com/x/web-interface/archive/related?aid=\(avId)"
    }
    
    static func getRanking(day: String) -> String{
        return "https://api.bilibili.com/x/web-interface/ranking?rid=0&day=\(day)&type=2&arc_type=1&jsonp=jsonp"
    }
    
    static func postClickH5() -> String{
        return "https://api.bilibili.com/x/click-interface/click/web/h5"
    }
}

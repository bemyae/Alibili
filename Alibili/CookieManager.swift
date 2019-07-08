//
//  CookieManager.swift
//  Alibili
//
//  Created by Xiaonan Zhang on 2019/07/08.
//  Copyright © 2019 Xiaonan Zhang. All rights reserved.
//

import Foundation

class CookieManager {
    
    
    func isUserCookieSet(forKey: String) -> Bool {
        if (UserDefaults.standard.string(forKey: forKey) != nil) {
            return true
        }
        return false
    }
    
    func saveUserCookie(forKey: String, response: HTTPURLResponse) {
        if let fields = response.allHeaderFields as? [String: String], let _ = response.url {
            let cookie = fields["Set-Cookie"]
            if cookie != nil {
                UserDefaults.standard.set(cookie, forKey: forKey)
            }
        }
    }
    
    func removeUserCookie(forKey: String) {
        if (isUserCookieSet(forKey: forKey)) {
            UserDefaults.standard.removeObject(forKey: forKey)
        }
        if(isUserCookieSet(forKey: forKey)){
            print(getUserCookie(forKey: forKey)!)
        }else{
            print("logouted")
        }
    }
    
    func getUserCookie(forKey: String) -> String? {
        if (UserDefaults.standard.string(forKey: forKey) != nil) {
            return UserDefaults.standard.string(forKey: forKey)!
        }
        return nil
    }
    
    // HTTPURLResponseから特定のCookieを探し、HTTPCookieStorageに保存する
    func loadCookie(name: String, response: HTTPURLResponse) {
        if let fields = response.allHeaderFields as? [String: String], let url = response.url {
            for cookie in HTTPCookie.cookies(withResponseHeaderFields: fields, for: url) {
                if (cookie.name == name) {
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
            }
        }
    }
    
    // Url, Key, ValueからCookie文字列を生成し、HTTPCookieStrageに保存する
    func setCookie(url: URL, key: String, value: String) {
        let cookieStr = key + "=" + value + ";Secure"
        let cookieHeaderField = ["Set-Cookie": cookieStr]
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: url)
        
        HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: url)
    }
    
    // HTTPCookieStorageから特定のCookieを取得する
    func getCookie(name: String, url: URL) -> String? {
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            for cookie in cookies {
                if (cookie.name == name) {
                    print(cookie)
                    return cookie.value
                }
            }
        }
        
        return nil
    }
    
    // HTTPCookieStorageに特定のCookieが保存されているかを調べる
    func isCookieSet(name: String, url: URL) -> Bool {
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            for cookie in cookies {
                if (cookie.name == name) {
                    return true
                }
            }
        }
        
        return false
    }
    
    // HTTPCookieStorageから特定のCookieを削除する
    func removeCookie(name: String, url: URL) {
        if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            for cookie in cookies {
                if (cookie.name == name) {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }
        }
    }
}

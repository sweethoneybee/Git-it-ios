//
//  UserInfo.swift
//  Git-it
//
//  Created by 정성훈 on 2021/05/13.
//

import Foundation

struct UserInfo {
    enum Key: String {
        case username
        case friendList
        case profileImageData
        case profileImageKey
    }
    
    private init() {}
    
    static var username: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.username.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.username.rawValue)
        }
    }
    
    static var friendList: [String]? {
        get {
            return UserDefaults.standard.stringArray(forKey: Key.friendList.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.friendList.rawValue)
        }
    }
    
    static var profileImageKey: URL? {
        get {
            guard let urlStr = UserDefaults.standard.string(forKey: Key.profileImageKey.rawValue) else {
                return nil
            }
            return URL(string: urlStr)
        }
        set {
            let value = newValue?.absoluteString
            return UserDefaults.standard.set(value, forKey: Key.profileImageKey.rawValue)
        }
    }
    
    static func remove(forKey key: UserInfo.Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}

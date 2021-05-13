//
//  UserInfo.swift
//  Git-it
//
//  Created by 정성훈 on 2021/05/13.
//

import Foundation

struct UserInfo {
    enum Key: String {
        case username = "USER_NAME"
        case friendList = "FRIEND_LIST"
        case profileImageData = "USER_PHOTO_IMAGE_DATA"
    }
    
    private init() {}
    
    static var username: String? {
        get {
            let userDefaults = UserDefaults.standard
            return userDefaults.string(forKey: Key.username.rawValue)
        }
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: Key.username.rawValue)
        }
    }
    
    static var friendList: [String]? {
        get {
            let userDefaults = UserDefaults.standard
            return userDefaults.stringArray(forKey: Key.friendList.rawValue)
        }
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: Key.friendList.rawValue)
        }
    }
    
    static var profileImageData: Data? {
        get {
            let userDefaults = UserDefaults.standard
            return userDefaults.data(forKey: Key.profileImageData.rawValue)
        }
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: Key.profileImageData.rawValue)
        }
    }
    
    static func remove(forKey key: UserInfo.Key) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key.rawValue)
    }
}

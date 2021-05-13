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
    
    static var profileImageData: Data? {
        get {
            return UserDefaults.standard.data(forKey: Key.profileImageData.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.profileImageData.rawValue)
        }
    }
    
    static func remove(forKey key: UserInfo.Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}

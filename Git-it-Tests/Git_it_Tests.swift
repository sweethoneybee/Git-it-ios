//
//  Git_it_Tests.swift
//  Git-it-Tests
//
//  Created by 정성훈 on 2021/05/13.
//

import XCTest
@testable import Git_it

class Git_it_Tests: XCTestCase {
    let username = "Joe"
    let friendList = ["Ahn", "Lee", "Ha", "Hoe"]
    let imageKey = "www.google.com"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        UserInfo.username = username
        UserInfo.friendList = friendList
        UserInfo.profileImageKey = URL(string: imageKey)!
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UserInfo.remove(forKey: .username)
        UserInfo.remove(forKey: .friendList)
        UserInfo.remove(forKey: .profileImageKey)
    }

    func testUserInfoClass() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // given
        let newUserName = "Jeong"
        let newFriendList = ["Kim", "Park", "Seo"]
        let newProfileImageKey = URL(string:"www.queness.com/resources/images/png/apple_web.png")!
        
        // when
        UserInfo.username = newUserName
        UserInfo.friendList = newFriendList
        UserInfo.profileImageKey = newProfileImageKey
        
        // then
        XCTAssertEqual(newUserName, UserInfo.username)
        XCTAssertEqual(newFriendList, UserInfo.friendList)
        XCTAssertEqual(newProfileImageKey, UserInfo.profileImageKey)
    }

    func testUpdatFriendList() throws {
        // given
        let oldFrinedList = UserInfo.friendList
        let updateFriendList = ["me", "you"]
        
        // when
        UserInfo.friendList = updateFriendList
        
        // then
        XCTAssertEqual(oldFrinedList?.count, self.friendList.count)
        XCTAssertEqual(updateFriendList, UserInfo.friendList)
    }
}

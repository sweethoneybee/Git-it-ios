//
//  ImageCache_Tests.swift
//  Git-it-Tests
//
//  Created by 정성훈 on 2021/06/04.
//

import XCTest
@testable import Git_it

class ImageCache_Tests: XCTestCase {

    var testImage: UIImage!
    let url = URL(string: "www.queness.com/resources/images/png/apple_web.png")!
    override func setUpWithError() throws {
        self.testImage = try? UIImage(data: Data(contentsOf: url))!
        UserInfo.profileImageKey = url
    }

    override func tearDownWithError() throws {
        UserInfo.remove(forKey: .profileImageKey)
    }

    func test_ImageCacheLoadSuccess() {
        let expectation = XCTestExpectation()
        if let key = UserInfo.profileImageKey as NSURL? {
            ImageCache.shared.load(url: key) { image in
                XCTAssertEqual(self.testImage, image)
                expectation.fulfill()
            }
        } else {
            XCTFail()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}

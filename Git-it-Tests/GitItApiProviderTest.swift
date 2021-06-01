//
//  GitItApiProviderTest.swift
//  Git-it-Tests
//
//  Created by 정성훈 on 2021/06/01.
//

import XCTest
@testable import Git_it

class GitItApiProviderTest: XCTestCase {

    var sut: GitItApiProvider!
    override func setUpWithError() throws {
        UserInfo.username = "jeong"
        UserInfo.friendList = ["jeong", "seong"]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UserInfo.remove(forKey: .username)
        UserInfo.remove(forKey: .friendList)
    }

    func test_fetchCommitsSummary() {
        sut = .init(session: MockURLSession())
        let expectation = XCTestExpectation()
        let response = try? JSONDecoder().decode(CommitsSummary.self, from: GitItApi.commitsSummary(UserInfo.username!).sampleData)
        
        sut.fetchCommitsSummary { result in
            switch result {
            case .success(let summary):
                XCTAssertEqual(summary.validation, response?.validation)
                XCTAssertEqual(summary.username, response?.username)
                XCTAssertNotNil(summary.commitsRecord.first)
                XCTAssertEqual(summary.commitsRecord.first, response?.commitsRecord.first)
                XCTAssertEqual(summary.profileImageUrl, response?.profileImageUrl)
                XCTAssertEqual(summary.commitStreak, response?.commitStreak)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func test_fetchCommitsSummary_failure() {
        sut = .init(session: MockURLSession(makeRequestFail: true))
        let expectation = XCTestExpectation()
        
        sut.fetchCommitsSummary { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, ApiError.serverError(nil).localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchSocialCommitsSummary() {
        sut = .init(session: MockURLSession(makeRequestFail: false, fetchCase: .socialCommitsSummary))
        let expecation = XCTestExpectation()
        let response = try? JSONDecoder().decode([SocialCommitsSummary].self, from: GitItApi.social.sampleData)
        
        sut.fetchSocialCommitsSummary { result in
            switch result {
            case .success(let summaries):
                XCTAssertEqual(summaries.count, response?.count)
                for i in 0..<summaries.count {
                    XCTAssertEqual(summaries[i].validation, response?[i].validation)
                    XCTAssertEqual(summaries[i].username, response?[i].username)
                    XCTAssertEqual(summaries[i].commitsRecord.count, response?[i].commitsRecord.count)
                }
            case .failure:
                XCTFail()
            }
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 2.0)
    }
    
    func test_fetchSocialCommitsSummary_failure() {
        sut = .init(session: MockURLSession(makeRequestFail: true, fetchCase: .socialCommitsSummary))
        let expectation = XCTestExpectation()
        
        sut.fetchSocialCommitsSummary { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, ApiError.serverError(nil).localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchStatsData() {
        sut = .init(session: MockURLSession(makeRequestFail: false, fetchCase: .stats))
        let expecation = XCTestExpectation()
        let response = try? JSONDecoder().decode(StatsData.self, from: GitItApi.stats(UserInfo.username!).sampleData)
        
        sut.fetchStatsData { result in
            switch result {
            case .success(let stats):
                XCTAssertEqual(stats.validation, response?.validation)
                XCTAssertEqual(stats.tier, response?.tier)
                XCTAssertEqual(stats.totalCommits, response?.totalCommits)
                XCTAssertEqual(stats.average, response?.average)
                XCTAssertEqual(stats.maxCommitStreak, response?.maxCommitStreak)
            case .failure:
                XCTFail()
            }
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 2.0)
    }
    
    func test_fetchStatsData_failure() {
        sut = .init(session: MockURLSession(makeRequestFail: true, fetchCase: .stats))
        let expectation = XCTestExpectation()
        
        sut.fetchStatsData { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, ApiError.serverError(nil).localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
//struct StatsData: Decodable {
//    var validation: String
//    var tier: String
//    var totalCommits: Int
//    var average: Int
//    var maxCommitStreak: Int
//}

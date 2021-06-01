//
//  MockData.swift
//  Git-it
//
//  Created by 정성훈 on 2021/06/01.
//

import Foundation

// MARK: - Test Data
extension GitItApi {
    var sampleData: Data {
        switch self {
        case .commitsSummary(let username):
            return Data(
                """
                {
                  "validation": "VALID",
                  "username": "\(username)",
                  "commitsRecord": [
                                {
                                    "count": 3,
                                    "date": "2019-05-05",
                                    "level": 1
                                },
                                {
                                    "count": 5,
                                    "date": "2019-05-06",
                                    "level": 2
                                }
                            ],
                  "profileImageUrl": "임시.url",
                  "commitStreak": 30
                }
                """.utf8
            )
        case .social:
            return Data(
            """
            [
              {
                "validation": "VALID",
                "username": "jeong",
                "commitsRecord": [
                  {
                    "count": 3,
                    "date": "2019-05-05",
                    "level": 1
                  },
                  {
                    "count": 5,
                    "date": "2019-05-06",
                    "level": 2
                  }
                ]
              },
              {
                "validation": "VALID",
                "username": "seong",
                "commitsRecord": [
                  {
                    "count": 3,
                    "date": "2019-05-05",
                    "level": 1
                  },
                  {
                    "count": 5,
                    "date": "2019-05-06",
                    "level": 2
                  }
                ]
              }
            ]
            """.utf8
            )
        case .stats:
            return Data(
            """
            {
              "validation": "VALID",
              "tier": "Silver",
              "totalCommits": 50,
              "average": 3,
              "maxCommitStreak": 40
            }
            """.utf8
            )
        }
        
    }
}

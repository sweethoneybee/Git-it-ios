//
//  CodableStructs.swift
//  Git-it
//
//  Created by 정성훈 on 2021/05/19.
//

import Foundation

struct commitsSummary: Decodable {
    var validation: String
    var username: String
    var commitsRecord: [commitsRecord]
    var profileImageUrl: String
    var commitStreak: Int
}

struct commitsRecord: Decodable {
    var count: Int
    var date: String
    var level: Int
}

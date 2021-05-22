//
//  CodableStructs.swift
//  Git-it
//
//  Created by 정성훈 on 2021/05/19.
//

import Foundation

struct CommitsSummary: Decodable {
    var validation: String
    var username: String
    var commitsRecord: [CommitsRecord]
    var profileImageUrl: String
    var commitStreak: Int
}

struct CommitsRecord: Decodable {
    var count: Int
    var date: String
    var level: Int
}

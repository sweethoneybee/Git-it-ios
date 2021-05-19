//
//  CommitsApiProvider.swift
//  Git-it
//
//  Created by 정성훈 on 2021/05/18.
//

import Foundation

enum GitItApi {
    case commitsSummary
    case social
    case stats
    
    static let baseUrl = "http://임시url입니다.수정.예정"
    
    var path: String {
        switch self {
        case .commitsSummary: return "/commitsSummary"
        case .social: return "/social"
        case .stats: return "/stats"
        }
    }
    
    var url: URL { URL(string: GitItApi.baseUrl + self.path)! }
}

enum ApiError: LocalizedError {
    case unknownError
    var errorDescription: String? { "unknownError" }
}

class GitItApiProvider {
    let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchCommitsSummary(completion: @escaping (Result<commitsSummary, Error>) -> Void) {
        let request = URLRequest(url: GitItApi.commitsSummary.url)
        
        let task: URLSessionTask = self.session.dataTask(with: request) { data, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse,
               (200...399).contains(response.statusCode) else {
                completion(.failure(error ?? ApiError.unknownError))
                return
            }
            
            if let data = data, let commitsSummary = try? JSONDecoder().decode(commitsSummary.self, from: data) {
                completion(.success(commitsSummary))
                return
            }
            completion(.failure(ApiError.unknownError))
        }
        
        task.resume()
    }
}

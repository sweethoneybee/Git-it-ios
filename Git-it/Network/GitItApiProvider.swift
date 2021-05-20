//
//  CommitsApiProvider.swift
//  Git-it
//
//  Created by 정성훈 on 2021/05/18.
//

import Foundation

enum ApiError: LocalizedError {
    case noUsernameError
    case clientError(Error)
    case serverError(URLResponse?)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .noUsernameError: return "no username error"
        case .clientError: return "client error"
        case .serverError: return "server error"
        case .unknownError: return "unknown error"
        }
    }
}

enum GitItApi {
    case commitsSummary(String)
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
    
    var queryItem: String {
        switch self {
        case .commitsSummary(let username): return "?username=\(username)"
        case .social: return ""
        case .stats: return ""
        }
    }
    
    var url: URL { URL(string: GitItApi.baseUrl + self.path + self.queryItem)! }
}

// MARK:- APIs
class GitItApiProvider {
    let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchCommitsSummary(completion: @escaping (Result<commitsSummary, Error>) -> Void) {
        guard let username = UserInfo.username else {
            completion(.failure(ApiError.noUsernameError))
            return
        }
        
        let request = URLRequest(url: GitItApi.commitsSummary(username).url)
        let task: URLSessionTask = self.session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(ApiError.clientError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
               (200...399).contains(httpResponse.statusCode) else {
                completion(.failure(ApiError.serverError(response)))
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

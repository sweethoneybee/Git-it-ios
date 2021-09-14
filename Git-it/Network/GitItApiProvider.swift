//
//  CommitsApiProvider.swift
//  Git-it
//
//  Created by 정성훈 on 2021/05/18.
//

import Foundation

enum ApiError: LocalizedError {
    case noUsernameError
    case noFriendListError
    case clientError(Error)
    case serverError(URLResponse?)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .noUsernameError: return "no username error"
        case .noFriendListError: return "no friendList error"
        case .clientError: return "client error"
        case .serverError: return "server error"
        case .unknownError: return "unknown error"
        }
    }
}

enum GitItApi {
    case commitsSummary(String)
    case social
    case stats(String)
    
    static let baseUrl = "http://testurl.will.replace/"
    
    var path: String {
        switch self {
        case .commitsSummary: return "commitsSummary/"
        case .social: return "social/"
        case .stats: return "stats/"
        }
    }
    
    var queryItem: String? {
        switch self {
        case .commitsSummary(let username): return "?username=\(username)"
        case .social: return nil
        case .stats(let username): return "?username=\(username)"
        }
    }
    
    var url: URL { URL(string: GitItApi.baseUrl + self.path + (self.queryItem ?? ""))! }
}

// MARK: - APIs
/*
    // asynchronously fetch
     GitItApiProvider().fetchCommitsSummary { result in
         switch result {
         case .failure(let error):
            // error handling
         case .success(let commitsSummary):
            // UI must be handled in Main Queue
         }
     }
 */
class GitItApiProvider {
    let session: URLSessionProtocol
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // test
    func checkId(username: String, completion: @escaping (Result<CommitsSummary, ApiError>) -> Void) {
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
            
            if let data = data, let commitsSummary = try? JSONDecoder().decode(CommitsSummary.self, from: data) {
                completion(.success(commitsSummary))
                return
            }
            completion(.failure(ApiError.unknownError))
        }
        
        task.resume()
    }
    
    func fetchCommitsSummary(completion: @escaping (Result<CommitsSummary, ApiError>) -> Void) {
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
            
            if let data = data, let commitsSummary = try? JSONDecoder().decode(CommitsSummary.self, from: data) {
                completion(.success(commitsSummary))
                return
            }
            completion(.failure(ApiError.unknownError))
        }
        
        task.resume()
    }
    
    func fetchSocialCommitsSummary(completion: @escaping (Result<[SocialCommitsSummary], ApiError>) -> Void) {
        guard let friendList = UserInfo.friendList,
              let httpBody = try? JSONEncoder().encode(friendList) else {
            completion(.failure(ApiError.noFriendListError))
            return
        }
        
        var request = URLRequest(url: GitItApi.social.url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
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
            
            if let data = data, let socialCommitsSummaryList = try? JSONDecoder().decode([SocialCommitsSummary].self, from: data) {
                completion(.success(socialCommitsSummaryList))
                return
            }
            completion(.failure(ApiError.unknownError))
        }
        
        task.resume()
    }
    
    func fetchStatsData(completion: @escaping (Result<StatsData, ApiError>) -> Void) {
        guard let username = UserInfo.username else {
            completion(.failure(ApiError.noUsernameError))
            return
        }
        
        let request = URLRequest(url: GitItApi.stats(username).url)
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
            
            if let data = data, let statsData = try? JSONDecoder().decode(StatsData.self, from: data) {
                completion(.success(statsData))
                return
            }
            completion(.failure(ApiError.unknownError))
        }
        
        task.resume()
    }
}

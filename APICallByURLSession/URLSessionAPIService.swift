//
//  URLSessionAPIService.swift
//  APICallByURLSession
//
//  Created by sohamp on 21/08/24.
//

import Foundation

enum APIError: Error, LocalizedError {
    case networkError(URLError)
    case decodingError(Error)
    case invalidURL
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return error.localizedDescription
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .invalidURL:
            return "The URL is invalid."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}


protocol APIService {
    // Generic
    func fetchDataByUrlSession<T:Codable>(from url:String,completion: @escaping(Result<T,APIError>) -> Void)
}


class URLSessionAPIService:APIService {
    private let session: URLSession
    
    // Dependency Injection
    init(session:URLSession = .shared) {
        self.session = session
    }
    
    // Protocol
   // func fetchDataByUrlSession<T>(from url: String, completion: @escaping (Result<T, APIError>) -> Void) where T : Decodable, T : Encodable {
      func fetchDataByUrlSession<T:Codable>(from url: String, completion: @escaping (Result<T, APIError>) -> Void){
            guard let url = URL(string:url) else {
                completion(.failure(.invalidURL))
                return
            }
            
            let task = session.dataTask(with: url) { data, response, error in
                    if let error = error as? URLError {
                        completion(.failure(.networkError(error)))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(.unknownError))
                        return
                    }
                    
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(.decodingError(error)))
                    }
            }
            task.resume()
    }
    
    
}

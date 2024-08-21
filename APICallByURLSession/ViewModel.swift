//
//  ViewModel.swift
//  APICallByURLSession
//
//  Created by sohamp on 21/08/24.
//

import Foundation

class ViewModel {
    private let apiService: APIService
    private(set) var todo: [Todo] = []
    var onError: ((String) -> Void)?
    var onUpdate: (() -> Void)?
    
    // Dependency Injection
    init(apiService:APIService = URLSessionAPIService()){
        self.apiService = apiService
    }
    
    func fetchTodos() {
        apiService.fetchDataByUrlSession(from: "https://jsonplaceholder.typicode.com/todos") {[weak self] (result:Result<[Todo],APIError>) in
            DispatchQueue.main.async {
                switch  result {
                case .success(let todo):
                    self?.todo = todo
                    self?.onUpdate?()
                    
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
            
        }
    }
}

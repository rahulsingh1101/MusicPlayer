//
//  NetworkRequest.swift
//  NetworkModule
//
//  Created by Rahul Singh on 16/05/24.
//

import Foundation

public protocol NetworkRequestProtocol {
    func performRequest<T: NetworkRequest>(_ request: T, completion: @escaping (Result<T.ResponseModel, Error>) -> Void)
}

final public class NetworkClient: NetworkRequestProtocol {
    public init() {}
    public func performRequest<T: NetworkRequest>(_ request: T, completion: @escaping (Result<T.ResponseModel, Error>) -> Void) {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Response Data Error", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try request.decodeResponse(data: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

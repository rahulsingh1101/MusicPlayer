import Foundation

//public protocol NetworkProtocol {
//    func
//}


public struct GetRequest<T: Decodable>: NetworkRequest {
    public init(url: URL, headers: [String : String]) {
        self.url = url
        self.headers = headers
    }
    
    public typealias ResponseModel = T
    
    public let url: URL
    public let headers: [String: String]
    
    public var method: String {
        return "GET"
    }
    
    public var body: Data? {
        return nil
    }
    
    public func decodeResponse(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}

public struct PostRequest<T: Encodable, U: Decodable>: NetworkRequest {
    public init(url: URL, headers: [String : String], bodyData: T) {
        self.url = url
        self.headers = headers
        self.bodyData = bodyData
    }
    
    public typealias ResponseModel = U
    
    public let url: URL
    public let headers: [String: String]
    public let bodyData: T
    
    public var method: String {
        return "POST"
    }
    
    public var body: Data? {
        return try? JSONEncoder().encode(bodyData)
    }
    
    public func decodeResponse(data: Data) throws -> U {
        return try JSONDecoder().decode(U.self, from: data)
    }
}

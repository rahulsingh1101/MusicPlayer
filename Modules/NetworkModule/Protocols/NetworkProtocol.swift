import Foundation

//public protocol NetworkProtocol {
//    func
//}


public protocol NetworkRequest {
    associatedtype ResponseModel: Decodable
    
    var url: URL { get }
    var method: String { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    
    func decodeResponse(data: Data) throws -> ResponseModel
}

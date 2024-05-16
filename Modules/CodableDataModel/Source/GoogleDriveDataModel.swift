//
//  NetworkRequest.swift
//  NetworkModule
//
//  Created by Rahul Singh on 16/05/24.
//

import Foundation

public struct DriveModel: Codable {
    public let files: [DriveFile]
    public let incompleteSearch: Bool
    public let kind: String
}

public struct DriveFile: Codable {
    public let id: String
    public let kind: String
    public let mimeType: String
    public let name: String
}

//
//  File.swift
//  
//
//  Created by Ram Kumar on 27/04/24.
//

import Foundation

public protocol RequestConvertible {
  
    var baseURL: URL { get }
    var scheme: String { get }
    
    // Path should start with "/"
    var path: String { get }
    
    var params: [URLQueryItem] { get }
    
    var url: URL? { get }
    var method: HttpMethod { get }
    func request() throws -> URLRequest
}

public extension RequestConvertible {
    var scheme: String {
        "https"
    }
}



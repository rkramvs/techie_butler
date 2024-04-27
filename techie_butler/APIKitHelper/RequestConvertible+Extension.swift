//
//  RequestConvertible+Extension.swift
//  techie_butler
//
//  Created by Ram Kumar on 27/04/24.
//

import Foundation
import APIKit

extension RequestConvertible {
    
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var url: URL? {
        var urlComponent = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponent?.path = path
        urlComponent?.queryItems = params
        return urlComponent?.url
    }
    
    func request() throws -> URLRequest {
        guard let url else {
            throw NetworkError.invalidURL
        }
        var request  = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}


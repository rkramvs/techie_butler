//
//  ListAPI.swift
//  techie_butler
//
//  Created by Ram Kumar on 27/04/24.
//

import Foundation
import APIKit

class PostListAPI {
    
    func getList() async throws -> [PostModel] {
        let data = try await APIKit.request(self, session: URLSession.shared)
        let posts =  try JSONDecoder().decode([PostModel].self, from: data)
        return posts
    }
}

extension PostListAPI: RequestConvertible {
    var path: String {
        "/posts"
    }
    
    var params: [URLQueryItem] {
        []
    }
    
    var method: HttpMethod {
        .get
    }
}

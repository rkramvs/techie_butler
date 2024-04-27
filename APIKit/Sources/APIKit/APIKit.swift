// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation


public struct APIKit {
    
    public static func request(_ requestConvertible: RequestConvertible, session: URLSession) async throws -> Data {
        let request = try requestConvertible.request()
        print(request.url)
        let (data, response) = try await session.data(for: request)
        if (response as? HTTPURLResponse)?.statusCode == 200 {
            return data
        }
        throw NetworkError.networkFailure
    }
}

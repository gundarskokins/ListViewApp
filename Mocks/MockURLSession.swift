//
//  MockURLSession.swift
//  ListViewApp
//
//  Created by Gundars Kokins on 08/09/2025.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    var dataToReturn: Data?
    var errorToThrow: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = errorToThrow {
            throw error
        }
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (dataToReturn ?? Data(), response)
    }
}

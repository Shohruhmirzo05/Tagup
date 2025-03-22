//
//  ApiClient.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 04/03/25.
//

import SwiftUI

class APIClient {
    
    static let shared = APIClient()
    
    private init() {}
    
    enum HTTPMethod: String {
        case post = "POST"
    }
    
    enum Endpoint {
        case lookImage(requiredType: String, imageData: String?)
        case lookKey(requiredType: String, word: String)
        
        fileprivate var url: URL {
            var baseURL = URL(string: AppEnvironment.current.baseUrl)!
            switch self {
            case .lookImage( _, _):
                baseURL = baseURL.appending(path: "lookup")
            case .lookKey( _, _):
                baseURL = baseURL.appending(path: "lookup")
            }
            return baseURL
        }
        
        fileprivate var method: HTTPMethod {
            switch self {
            default:
                return .post
            }
        }
    }
    
    func getRequest(of endpoint: Endpoint) -> URLRequest {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        let headers: [String: String] = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        var requestBody: [String: Any?] = [:]
        switch endpoint {
        case .lookImage(_, let imageData):
            requestBody = [
                "req_type" : "image_tags",
                "image" : imageData
            ]
        case .lookKey(_, let word):
            requestBody = [
                "req_type": "tags",
                "word": word
            ]
        }
        request.allHTTPHeaderFields = headers
        if !requestBody.isEmpty {
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: .fragmentsAllowed)
        }
        return request
    }
}

extension APIClient {
    
    func callWithStatusCode<T: Codable>(_ endpoint: Endpoint, decodeTo: T.Type) async throws -> (data: T, statusCode: Int) {
        let request = getRequest(of: endpoint)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "InvalidResponse", code: -1, userInfo: nil)
        }
        let statusCode = httpResponse.statusCode
        Log.info("\nRequest: \(request.cURL())")
        if let jsonString = data.prettyPrintedJSONString {
            Log.info("\(jsonString)")
        }
        let parsedData = try JSONDecoder().decode(T.self, from: data)
        return (data: parsedData, statusCode: statusCode)
    }
    
    func call<T: Codable>(_ endpoint: Endpoint, decodeTo: T.Type) async throws -> T {
        let request = getRequest(of: endpoint)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "InvalidResponse", code: -1, userInfo: nil)
        }
        let /*statusCode*/_ = httpResponse.statusCode
        Log.info("\nRequest: \(request.cURL())")
        if let jsonString = data.prettyPrintedJSONString {
            Log.info("\(jsonString)")
        }
        let parsedData = try JSONDecoder().decode(T.self, from: data)
        return parsedData
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension URLRequest {
    func cURL() -> String {
        var curl = "curl --location"
        if let location = self.url?.absoluteString {
            curl += " --request \(self.httpMethod?.uppercased() ?? "GET") '\(location)'"
        }
        if let headers = self.allHTTPHeaderFields {
            for (key, value) in headers {
                curl += " \\\n--header '\(key): \(value)'"
            }
        }
        if let httpBody = self.httpBody, let bodyString = String(data: httpBody, encoding: .utf8), !bodyString.isEmpty {
            curl += " \\\n--data '\(bodyString)'"
        }
        return curl
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
}

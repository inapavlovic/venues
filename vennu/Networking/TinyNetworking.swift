//
//  TinyNetworking.swift
//  vennu
//
//  Created by Ina Statkic on 22/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

enum HttpMethod<Body> {
    case get
    case post(Body)
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

// MARK: - Resource

struct Resource<A> {
    var urlRequest: URLRequest
    let convert: (Data) -> A?
}

extension Resource where A: Decodable {
    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
        self.convert = { data in
            try? JSONDecoder().decode(A.self, from: data)
        }
    }
    
    init<Body: Encodable>(urlRequest: URLRequest, method: HttpMethod<Body>) {
        self.urlRequest = urlRequest
        self.urlRequest.httpMethod = method.method
        switch method {
        case .get: ()
        case .post(let body):
            self.urlRequest.httpBody = try! JSONEncoder().encode(body)
        }
        self.convert = { data in
            try? JSONDecoder().decode(A.self, from: data)
        }
    }
}

// MARK: - Resource/Response

struct ResourceResponse<A, B> {
    var urlRequest: URLRequest
    var convertResponse: (Data) -> B?
}

extension ResourceResponse where B: Decodable {
    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
        self.convertResponse = { data in
            try? JSONDecoder().decode(B.self, from: data)
        }
    }
    
    init<A: Encodable>(urlRequest: URLRequest, method: HttpMethod<A>) {
        self.urlRequest = urlRequest
        self.urlRequest.httpMethod = method.method
        switch method {
        case .get: ()
        case .post(let body):
            self.urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            self.urlRequest.httpBody = try! JSONEncoder().encode(body)
        }
        self.convertResponse = { data in
            try? JSONDecoder().decode(B.self, from: data)
        }
    }
}

// MARK: - URLSession

extension URLSession {
    func load<A>(_ resource: Resource<A>, _ completion: @escaping (A?) -> ()) {
        dataTask(with: resource.urlRequest) { data, response, error in
            completion(data.flatMap(resource.convert))
        }.resume()
    }
}

// MARK: - Result

enum Result<A> {
    case error(Error)
    case success(A)
}

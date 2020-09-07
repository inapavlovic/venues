//
//  StripeManager.swift
//  users
//
//  Created by Ina Statkic on 07/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation
import Stripe

final class StripeManager: NSObject {
    
    // MARK: Properties
    
    static let shared = StripeManager()
    
    private static let basePath = "https://us-central1-vennue-b35b7.cloudfunctions.net/api"
    private static let headers: [String : String] = {
        return [
            "User-Agent" : "Vennu",
            "Accept-Charset" : "utf-8"
        ]
    }()

}
// MARK: - Endpoints


extension StripeManager {
    enum CustomerType: String {
        case create
        case update
        case addCard = "add-card"
    }
    
    enum Endpoint {
        case pay
        case token
        case customer(id: String?, type: CustomerType?)
        
        private var url: URL {
            guard let baseURL = URL(string: basePath) else { fatalError() }
            var stripeURL = baseURL.appendingPathComponent("stripe")
            switch self {
            case .pay:
                return baseURL.appendingPathComponent("vennu").appendingPathComponent("book")
            case .token:
                return stripeURL.appendingPathComponent("token").appendingPathComponent("create")
            case .customer(let id, let type):
                stripeURL = stripeURL.appendingPathComponent("customer")
                if let customerId = id {
                    stripeURL = stripeURL.appendingPathComponent(customerId)
                }
                if let type = type {
                    stripeURL = stripeURL.appendingPathComponent(type.rawValue)
                }
                return stripeURL
            }
        }
        
        fileprivate var urlRequest: URLRequest {
            guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                fatalError("Invalid URL")
            }
            guard let composedURL = urlComponents.url else { fatalError() }
            var request = URLRequest(url: composedURL)
            request.allHTTPHeaderFields = StripeManager.headers
            return request
        }
    }
    
}

// MARK: - URLSession

extension URLSession {
    func data<A, B>(_ resource: ResourceResponse<A, B>, _ completion: @escaping (B?) -> ()) {
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        currentUser.getIDTokenForcingRefresh(true) { [weak self] idToken, error in
            if let error = error {
                print(error)
                return
            }
            guard let token = idToken else { return }
            var urlRequest = resource.urlRequest
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            self?.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    debugPrint(StripeError.urlError(error as! URLError))
                    completion(nil)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    return
                }
//                if let data = data {
//                    let obj = try? JSONSerialization.jsonObject(with: data, options: [])
//                    print(obj)
//                }
                if !(200..<300).contains(httpResponse.statusCode) {
                    switch httpResponse.statusCode {
                    case 400:
                        debugPrint(StripeError.invalidResponse)
                    case 401:
                        debugPrint(StripeError.unauthorized)
                    default:
                        break
                    }
                    completion(nil)
                    return
                }
                completion(data.flatMap(resource.convertResponse))
            }.resume()
        }
    }
}

// MARK: - Methods

extension StripeManager {
    func createCustomer(completion: @escaping (Customer?) -> ()) {
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let endpoint: Endpoint = .customer(id: nil, type: .create)
        let customer = Customer(name: currentUser.displayName, email: currentUser.email, description: "iOS Customer")
        let resource = ResourceResponse<Customer, CustomerResponse>(urlRequest: endpoint.urlRequest, method: .post(customer))
        URLSession.shared.data(resource) {
            completion($0?.data)
        }
    }
    
    func createCardToken(with card: STPCardParams, completion: @escaping (Token?) -> ()) {
        let endpoint: Endpoint = .token
        let cardParams = CardParams(cardNumber: card.number!, expireMonth: Int(card.expMonth), expireYear: Int(card.expYear), cvc: card.cvc!)
//        let cardParams = CardParams(cardNumber: "4000056655665556", expireMonth: 4, expireYear: 25, cvc: "342")
        let resource = ResourceResponse<CardParams, TokenResponse>(urlRequest: endpoint.urlRequest, method: .post(cardParams))
        URLSession.shared.data(resource) {
            completion($0?.data)
        }
    }
    
    func addCard(toCustomer id: String, tokenId source: String, completion: @escaping (Card?) -> ()) {
        let endpoint: Endpoint = .customer(id: nil, type: .addCard)
        let addCard = AddCard(customerId: id, source: source)
        let resource = ResourceResponse<AddCard, CardResponse>(urlRequest: endpoint.urlRequest, method: .post(addCard))
        URLSession.shared.data(resource) {
            completion($0?.data)
        }
    }
    
    func book(_ booking: Booking, by customerId: String, withCard card: String, amount: Int, completion: @escaping (Outcome?) -> ()) {
        let endpoint: Endpoint = .pay
        let payment = Payment(source: card, amount: amount, customer: customerId)
        let book = Book(stripe: payment, booking: booking)
        let resource = ResourceResponse<Book, BookResponseContainer>(urlRequest: endpoint.urlRequest, method: .post(book))
        URLSession.shared.data(resource) {
            completion($0?.data.outcome)
        }
    }
    
    func customer(id: String, completion: @escaping (Customer?) -> ()) {
        let endpoint: Endpoint = .customer(id: id, type: nil)
        let resource = ResourceResponse<String, CustomerResponse>(urlRequest: endpoint.urlRequest)
        URLSession.shared.data(resource) {
            completion($0?.data)
        }
    }
    
    func updateCustomer(id: String, completion: @escaping () -> ()) {
        let endpoint: Endpoint = .customer(id: nil, type: .update)
        let cardId = UserDefaults.cardId
        let updateCard = UpdateCard(customerId: id, source: cardId)
        let resource = ResourceResponse<UpdateCard, CustomerResponse>(urlRequest: endpoint.urlRequest, method: .post(updateCard))
        URLSession.shared.data(resource) { _ in
            completion()
        }
    }
}

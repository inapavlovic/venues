//
//  StripeError.swift
//  users
//
//  Created by Ina Statkic on 16/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

enum StripeError: Error {
    case urlError(URLError)
    case unauthorized
    case invalidResponse
}

extension StripeError {
    var message: String? {
        switch self {
        case .unauthorized:
            return NSLocalizedString("Unauthorized", comment: "Add authorization token")
        case .invalidResponse:
            return NSLocalizedString("Invalid response", comment: "Data is not valid or incomplete")
        case .urlError(let urlError):
            return urlError.localizedDescription
        }
    }
}

//
//  Auth.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

struct Authentication {

    var email: String?
    var password: String?
    var name: String?
    var businessName: String?
    var companyID: Int?
    var phoneNumber: String?
    var address: String?
    
    var firstDigit: String?
    var secondDigit: String?
    var thirdDigit: String?
    var forthDigit: String?
    var fifthDigit: String?
    var sixthDigit: String?
    var verificationCode: String? {
        if
            let firstDigit = firstDigit,
            let secondDigit = secondDigit,
            let thirdDigit = thirdDigit,
            let forthDigit = forthDigit,
            let fifthDigit = fifthDigit,
            let sixthDigit = sixthDigit
        {
            return firstDigit + secondDigit + thirdDigit + forthDigit + fifthDigit + sixthDigit
        } else {
            return nil
        }
    }
    
    func validateName() throws {
        if name?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 == 0 {
            throw ValidateError.nameEmpty
        }
    }
    
    func validateEmail() throws {
        if email?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 == 0 {
            throw ValidateError.emailEmpty
        }
        
        if email?.isValidEmail() == false {
            throw ValidateError.emailFormat
        }
    }
    
    func validateEmailAndPassword() throws {
        try validateEmail()
        
        if password?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 == 0 {
            throw ValidateError.passwordEmpty
        }
        
        if password?.isValidPassword() == false {
            throw ValidateError.passwordFormat
        }
    }
    
    func validatePro() throws {
        try validateName()
        try validateComplete()
        try validateEmailAndPassword()
    }
    
    func validateComplete() throws {
        if businessName?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 == 0 {
            throw ValidateError.businessNameEmpty
        }
        
        if companyID ?? 0 == 0 {
            throw ValidateError.companyIDEmpty
        }
        
        if phoneNumber?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 == 0 {
            throw ValidateError.phoneNumberEmpty
        }
        
        if address?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 == 0 {
            throw ValidateError.addressEmpty
        }
    }
    
    func validateUser() throws {
        try validateName()
        try validateEmailAndPassword()
    }
    
    func validatePhoneNumber() throws {
        if phoneNumber?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 == 0 {
            throw ValidateError.phoneNumberEmpty
        }
    }
    
    func validateVerificationCode() throws {
        if verificationCode?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 == 0 {
            throw ValidateError.verificationCodeEmpty
        }
    }
    
    enum ValidateError: Error {
        case nameEmpty
        case businessNameEmpty
        case companyIDEmpty
        case phoneNumberEmpty
        case addressEmpty
        case emailEmpty
        case emailFormat
        case passwordEmpty
        case passwordFormat
        case verificationCodeEmpty
        
        var localizedDescription: String {
            switch self {
            case .nameEmpty: return "Please enter your name."
            case .businessNameEmpty: return "Please enter business name."
            case .companyIDEmpty: return "Please enter company ID."
            case .phoneNumberEmpty: return "Please enter phone number."
            case .addressEmpty: return "Please enter address."
            case .emailEmpty: return "Please enter email."
            case .emailFormat: return "Please enter valid email."
            case .passwordEmpty: return "Please enter password."
            case .passwordFormat:
                return "Please enter six characters long password with special character and number included."
            case .verificationCodeEmpty: return "Please enter the code sent to you."
            }
        }
    }
    
}

//
//  AppleIDButton.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import AuthenticationServices.ASAuthorizationAppleIDButton

class AppleIDButton: ASAuthorizationAppleIDButton {

    override init(authorizationButtonType type: ASAuthorizationAppleIDButton.ButtonType, authorizationButtonStyle style: ASAuthorizationAppleIDButton.Style) {
        super.init(authorizationButtonType: type, authorizationButtonStyle: style)
        set()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        set()
    }
    
    // MARK: - Set
    
    func set() {
        cornerRadius = frame.height / 2
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.02
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }

}

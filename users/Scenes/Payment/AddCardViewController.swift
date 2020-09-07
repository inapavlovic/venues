//
//  AddCardViewController.swift
//  users
//
//  Created by Ina Statkic on 13/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import Stripe

enum AddCardContext: Equatable {
    case booking
    case profile(type: StripeManager.CustomerType)
}

protocol AddCardDelegate: AnyObject {
    func card(_ vc: AddCardViewController, _ card: Card)
}

final class AddCardViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = ListFlowController(self)
    
    // MARK: Properties
    
    private var customerId: String?
    var booking: Booking!
    
    weak var delegate: AddCardDelegate?
    
    var context: AddCardContext = .booking
    var customerHaveACard: Bool = false
    
    // MARK: Elements
    
    private var cardTextField: STPPaymentCardTextField = {
        let textField = STPPaymentCardTextField()
        textField.textColor = .tuna
        textField.placeholderColor = .doveGray
        textField.borderWidth = 0
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
        view.backgroundColor = .desertStorm
        userCustomerId()
        setUI()
    }
    
    // MARK: - Set
    
    private func setUI() {
        view.addSubview(cardTextField)
        NSLayoutConstraint.activate([
            cardTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            cardTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    @objc func done() {
        addCard()
    }
}

// MARK: - Stripe Auth Context

extension AddCardViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

// MARK: - Web Services

extension AddCardViewController {
    private func userCustomerId() {
        activityIndicatorView.startAnimating()
        FirebaseManager.shared.userBy(FirebaseManager.shared.uid) { user in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                if let user = user {
                    self.customerId = user.customerId
                }
            }
        }
    }
    
    private func addCard() {
        let cardParams = STPCardParams()
        cardParams.number = cardTextField.cardParams.number
        cardParams.expMonth = UInt(cardTextField.expirationMonth)
        cardParams.expYear = UInt(cardTextField.expirationYear)
        cardParams.cvc = cardTextField.cvc
        StripeManager.shared.createCardToken(with: cardParams) { token in
            if let token = token, let customerId = self.customerId {
                DispatchQueue.main.async {
                    self.delegate?.card(self, token.card)
                }
                switch self.context {
                case .booking:
                    StripeManager.shared.addCard(toCustomer: customerId, tokenId: token.id) { card in
                        guard let card = card else { return }
                        UserDefaults.cardId = card.id
                        self.booking.bookDate = Date().timeIntervalSince1970
                        StripeManager.shared.book(self.booking, by: customerId, withCard: card.id, amount: self.booking.total!) { outcome in
                            if let outcome = outcome {
                                self.flowController.showSuccess(message: outcome.message)
                            }
                        }
                    }
                case .profile(let type):
                    switch type {
                    case .addCard:
                        StripeManager.shared.addCard(toCustomer: customerId, tokenId: token.id) { card in
                            guard let card = card else { return }
                            UserDefaults.cardId = card.id
                        }
                    case .create: ()
                    case .update:
                        StripeManager.shared.updateCustomer(id: customerId) {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Navigation

extension AddCardViewController {
    private func setNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem?.tintColor = .tuna
    }
}

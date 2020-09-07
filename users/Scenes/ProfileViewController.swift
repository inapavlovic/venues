//
//  ProfileViewController.swift
//  vennu
//
//  Created by Ina Statkic on 09/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import Stripe

struct Info {
    var title: Any
    var image: String
}

final class ProfileViewController: BaseViewController {
    
    // MARK: - Flow
    
    lazy var flowController = ListFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var paymentCardControl: PaymentCardControl!
    
    // MARK: - Properties
    
    var userInfo: [Info] = [] {
        didSet {
            child.items = userInfo
        }
    }
    
    private var last4: String = UserDefaults.last4 {
        didSet {
            UserDefaults.last4 = last4
            paymentCardControl.last4 = last4
        }
    }
    
    private var funding: String = UserDefaults.funding {
        didSet {
            UserDefaults.funding = funding
            paymentCardControl.funding = funding
        }
    }
    
    lazy var addCardViewController = AddCardViewController()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manageUser()
        setUI()
        setElements()
        setActions()
        addCardViewController.delegate = self
    }
    
    // MARK: - Elements
    
    let child = ItemsViewController<Info, DefaultCell>()
    
    private func setElements() {
        child.configure = {
            $1.textLabel?.text = "\($0.title)"
            $1.imageView?.image = UIImage(named: $0.image)
        }
        child.tableView.rowHeight = 48
        child.tableView.isScrollEnabled = false
        embed(child, into: userInfoView)
    }
    
    // MARK: - Set
    
    private func setUI() {
        if FirebaseManager.shared.currentUser != nil {
            nameLabel.text = FirebaseManager.shared.name.first()
            lastNameLabel.text = FirebaseManager.shared.name.last()
            paymentCardControl.last4 = last4
            paymentCardControl.funding = funding
        } else {
            nameLabel.text = nil
            lastNameLabel.text = nil
            paymentCardControl.last4 = ""
            paymentCardControl.funding = ""
        }
    }
    
    // MARK: - Actions
    
    private func setActions() {
        paymentCardControl.addTarget(self, action: #selector(addCard(_:)), for: .touchUpInside)
    }
    
    @objc func addCard(_ sender: Any) {
        if FirebaseManager.shared.currentUser != nil {
            addCardViewController.context = last4.isEmpty ? .profile(type: .addCard) : .profile(type: .update)
            addCardViewController.title = "ADD A CARD"
            let nc = PresentNavigationController(rootViewController: addCardViewController)
            present(nc, animated: true)
        }
    }

}

// MARK: - Add Card Delegate

extension ProfileViewController: AddCardDelegate {
    func card(_ vc: AddCardViewController, _ card: Card) {
        last4 = card.last4
        funding = card.funding
    }
}

// MARK: - Web Services

extension ProfileViewController {
    private func manageUser() {
        if FirebaseManager.shared.currentUser != nil {
            activityIndicatorView.startAnimating()
            FirebaseManager.shared.userBy(FirebaseManager.shared.uid) { user in
                self.activityIndicatorView.stopAnimating()
                self.userInfo = [
                    Info(title: user!.email, image: "envelope"),
                    Info(title: user!.phoneNumber ?? "", image: "phone")
                ]
                self.child.tableView.reloadData()
            }
        }
    }
}

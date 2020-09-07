//
//  ProfileViewController.swift
//  vennu
//
//  Created by Ina Statkic on 09/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import GooglePlaces

struct Info {
    var title: Any
    var image: String
    var tag: Int
}

final class ProfileViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = ProfileFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: - Properties
    
    var userInfo: [Info] = [] {
        didSet {
            child.items = userInfo
        }
    }
    lazy var auth = Authentication()
    let autocompleteViewController = GMSAutocompleteViewController()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUserName()
        manageUser()
        setElements()
        autocompleteViewController.delegate = self
        setAutocompleteAddress()
    }
    
    // MARK: - Elements
    
    let child = ItemsViewController<Info, DefaultInputCell>()
    
    private func setElements() {
        child.configure = {
            $1.textField.text = "\($0.title)"
            $1.textField.tag = $0.tag
            $1.imageView?.image = UIImage(named: $0.image)
        }
        child.tableView.rowHeight = 48
        child.tableView.isScrollEnabled = false
        embed(child, into: userInfoView)
    }
    
    private func setUserName() {
        nameLabel.text = FirebaseManager.shared.name.first()
        lastNameLabel.text = FirebaseManager.shared.name.last()
    }
    
    private func setAutocompleteAddress() {
        autocompleteViewController.view.tintColor = .coralRed
        autocompleteViewController.autocompleteFilter?.type = .address
    }
    
    // MARK: - Actions
    
    @IBAction func editUserInfo(_ sender: Any) {
        let children = child.tableView.visibleCells as! [DefaultInputCell]
        children.suffix(from: 1).forEach {
            $0.textField.delegate = self
            switch $0.textField.tag {
            case 1:
                $0.textField.keyboardType = .phonePad
                auth.phoneNumber = $0.textField.text
            case 2: auth.businessName = $0.textField.text
            case 3:
                auth.address = $0.textField.text
                $0.textField.addTarget(self, action: #selector(editingBegin(_:)), for: .editingDidBegin)
            case 4:
                $0.textField.keyboardType = .numberPad
                auth.companyID = Int($0.textField.text!)
            default:
                $0.textField.keyboardType = .default
            }
            $0.textField.isEnabled.toggle()
            $0.textField.edit.toggle()
            $0.textField.addTarget(self, action: #selector(self.textFieldEditingChanged(_:)), for: .editingChanged)
            $0.textField.addTarget(self, action: #selector(editingEnded(_:)), for: .editingDidEnd)
            $0.textField.addTarget(self, action: #selector(editingDidEnter(_:)), for: .editingDidEndOnExit)
            if $0.textField.isEnabled {
                editButton.setImage(UIImage(named: "pencil"), for: .normal)
            } else {
                editButton.setImage(UIImage(named: "square.and.pencil"), for: .normal)
            }
        }
    }
    
    @objc private func editingBegin(_ sender: Any) {
        present(autocompleteViewController, animated: true)
    }
    
    @objc func editingEnded(_ sender: Any) {
        manageUserInfo {
            self.flowController.showSuccess()
        }
    }
    
    @objc private func editingDidEnter(_ sender: Any) {
        manageUserInfo {
            self.flowController.showSuccess()
        }
    }
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        switch sender.tag {
        case 1: auth.phoneNumber = sender.text
        case 2: auth.businessName = sender.text
        case 4: auth.companyID = Int(sender.text!)
        default: break
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 1:
            textField.text = textField.text?.formatPhoneNumber()
            return string.rangeOfCharacter(from: CharacterSet(charactersIn: "+0123456789").inverted) == nil
        case 4:
            return string.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789").inverted) == nil
        default:
            return true
        }
    }
}

// MARK: - Autocomplete Delegate

extension ProfileViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true)
        auth.address = place.formattedAddress ?? ""
        let children = child.tableView.visibleCells as! [DefaultInputCell]
        children[3].textField.text = place.formattedAddress ?? ""
        manageUserInfo {
            self.flowController.showSuccess()
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        navigationController?.dismiss(animated: true)
    }
}

// MARK: - Web Services

extension ProfileViewController {
    private func manageUser() {
        activityIndicatorView.startAnimating()
        FirebaseManager.shared.userBy(FirebaseManager.shared.uid) { user in
            self.activityIndicatorView.stopAnimating()
            self.userInfo = [
                Info(title: user!.email, image: "envelope", tag: 0),
                Info(title: user!.phoneNumber!, image: "phone", tag: 1),
                Info(title: user!.businessName!, image: "briefcase", tag: 2),
                Info(title: user!.address!, image: "location", tag: 3),
                Info(title: user!.companyID!, image: "tag", tag: 4)
            ]
            self.child.tableView.reloadData()
        }
    }
    
    private func manageUserInfo(completion: @escaping () -> ()) {
        FirebaseManager.shared.completeUser(FirebaseManager.shared.uid, auth, .pro) {
            completion()
        }
    }
}

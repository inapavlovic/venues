//
//  SettingsViewController.swift
//  vennu
//
//  Created by Ina Statkic on 09/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import MessageUI

final class SettingsViewController: UIViewController {
    
    // MARK: Flow
    
    lazy var flowController = SettingsFlowController(self)
    
    // MARK: - Properties
    
    var state = Settings.allCases {
        didSet {
            child.items = state
        }
    }
    var notify: Bool = true
    var appURL: URL?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .desertStorm
        addElements()
        setElementsActions()
        manageApp()
        if FirebaseManager.shared.currentUser != nil {
            manageNotifications()
        }
    }
    
    // MARK: - Elements
    
    let child = ItemsViewController(items: Settings.allCases, configure: { (item, cell: SettingsCell) in
        cell.textLabel?.text = item.name
        cell.imageView?.image = item.image
    })

    private func addElements() {
        embed(child, into: view) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: $1.safeAreaLayoutGuide.topAnchor, constant: 28),
                $0.leadingAnchor.constraint(equalTo: $1.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: $1.trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor)
            ])
        }
        child.tableView.rowHeight = 54
    }
    
    // MARK: - Actions
    
    private func setElementsActions() {
        child.didSelectAt = { item, indexPath in
            switch item {
            case .notifications:
                self.notify.toggle()
                self.manageNotify()
                print(item, indexPath.row)
            case .privacyPolicy:
                self.flowController.viewPrivacyPolicy()
            case .termsConditions:
                self.flowController.readTermsAndConditions()
            case .rate:
                guard let appURL = self.appURL else { return }
                UIApplication.shared.open(appURL)
            case .share: self.shareApp(indexPath)
            case .techSupport: self.sendEmail()
            case .customerSupport: self.sendEmail()
            case .sign:
                if FirebaseManager.shared.currentUser != nil {
                    self.signOut()
                } else {
                    self.flowController.goToAuth()
                }
            }
        }
    }
    
    private func subscribeToNotifications() {
        if notify == true {
            let userNotificationCenter = UNUserNotificationCenter.current()
            userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                print("Permission granted: \(granted)")
            }
        }
    }
    
    private func signOut() {
        alert(title: "Log out", message: "Are you sure you want to log out?", actions: "Log out") {
            if $0 == 0 {
                FirebaseManager.shared.signOutSocial()
                FirebaseManager.shared.signOut { (error) in
                    if error == nil {
                        #if PRO
                        self.flowController.goToAuth()
                        UserDefaults.admin = false
                        #elseif USER
                        self.flowController.goToExplore()
                        #endif
                    }
                }
            }
        }
    }
    
    private func shareApp(_ indexPath: IndexPath) {
        guard let url = self.appURL?.absoluteString else { return }
        let activityViewController = UIActivityViewController(activityItems: [self, url], applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            let selectedCell = child.tableView.cellForRow(at: indexPath)!
            popoverPresentationController.sourceRect = selectedCell.frame
            popoverPresentationController.sourceView = child.tableView
            popoverPresentationController.permittedArrowDirections = .up
        }
        present(activityViewController, animated: true)
    }
    
    private func sendEmail() {
        if !MFMailComposeViewController.canSendMail() { return }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.view.tintColor = .coralRed
        composeVC.setToRecipients(["vennu@upgraders.com"])
        self.present(composeVC, animated: true, completion: nil)
    }
}

// MARK: - Mail Compose Delegate

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

// MARK: - Activity Item Source

extension SettingsViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Vennu"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        guard let url = self.appURL?.absoluteString else { return "" }
        if activityType == .some(.postToTwitter) {
            return "#Vennu \(url)"
        } else {
            return url
        }
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "Vennu app"
    }
}

// MARK: - Web Services

extension SettingsViewController {
    private func manageApp() {
        FirebaseManager.shared.appURL { url in
            self.appURL = url
        }
    }
    
    private func manageNotify() {
        FirebaseManager.shared.notifications(notify: notify) { error in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func manageNotifications() {
        FirebaseManager.shared.notifications { status in
            self.notify = status
            self.state[0] = Settings.notifications(status)
            self.child.tableView.reloadData()
        }
    }
}

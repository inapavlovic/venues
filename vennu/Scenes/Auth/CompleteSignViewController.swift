//
//  CompleteSignViewController.swift
//  vennu
//
//  Created by Ina Statkic on 07/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class CompleteSignViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = AuthFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet weak var formView: FormView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions
    
    @IBAction func completeSign(_ sender: Any) {
        do {
            try formView.auth.validateComplete()
            activityIndicatorView.startAnimating()
            manageCompleteSign()
        } catch let error as Authentication.ValidateError {
            showError(title: "", message: error.localizedDescription)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
}

// MARK: - Web Services

extension CompleteSignViewController {
    private func manageCompleteSign() {
        FirebaseManager.shared.completeUser(FirebaseManager.shared.uid, formView.auth, .pro) {
            self.activityIndicatorView.stopAnimating()
            self.flowController.goToList()
        }
    }
}

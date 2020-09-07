//
//  DocumentViewController.swift
//  vennu
//
//  Created by Ina Statkic on 10/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import PDFKit

class DocumentViewController: UIViewController {
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Control
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
        setActivityIndicator()
        set()
    }
    
    // MARK: - Set
    
    private func set() {
        view.backgroundColor = .desertStorm
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(frame: view.frame)
        view.addSubview(activityIndicatorView)
    }
    
    // MARK: - Actions
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - Web Services

extension DocumentViewController {
    func document(_ document: String) {
        activityIndicatorView.startAnimating()
        FirebaseManager.shared.document(document) { data in
            self.activityIndicatorView.stopAnimating()
            if let data = data {
                if let pdf = PDFDocument(data: data) {
                    let documentContent = NSMutableAttributedString()
                    for i in 0 ... pdf.pageCount {
                        guard let page = pdf.page(at: i) else { continue }
                        guard let content = page.attributedString else { continue }
                        documentContent.append(content)
                    }
                    documentContent.addAttributes([
                        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                        NSAttributedString.Key.foregroundColor : UIColor.doveGray,
                        NSAttributedString.Key.kern : 0.17
                    ], range: NSMakeRange(0, documentContent.length))
                    self.textView.attributedText = documentContent
                }
            }
        }
    }
}

extension DocumentViewController {
    private func setNavigation() {
        let image = UIImage(systemName: "chevron.left" )?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .medium))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = .tuna
    }
}

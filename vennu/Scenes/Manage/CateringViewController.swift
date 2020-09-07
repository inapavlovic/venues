//
//  CateringViewController.swift
//  vennu
//
//  Created by Ina Statkic on 22.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class CateringViewController: UIViewController {
    
    // MARK: Flow
    
    lazy var flowController = ManageFlowController(self)
    
    // MARK: - Elements
    
    private var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: CateringSegment.allCases.map { $0.rawValue.uppercased() })
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.addTarget(self, action: #selector(segmentChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.tuna, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.kern : 0.92], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.coralRed, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.kern : 0.92], for: .selected)
        return segmentedControl
    }()
    
    private var scrollView: UIScrollView!
    
    private var textView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 280, height: 126))
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        textView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    private var textViewHeight: NSLayoutConstraint!

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 27)
        label.textColor = .coralRed
        label.text = "£"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var priceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = .boldSystemFont(ofSize: 27)
        textField.textColor = .coralRed
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: Properties
    
    private var catering = CateringPrice() {
        didSet {
            if segmentedControl.selectedSegmentIndex == 0 {
                textView.text = catering.premiumInfo
                let style = NSMutableParagraphStyle()
                style.lineSpacing = 4.0
                textView.attributedText = NSAttributedString(string: catering.premiumInfo, attributes: [.font : UIFont.systemFont(ofSize: 14), .paragraphStyle : style, .foregroundColor : UIColor.aluminum])
                priceTextField.text = "\(Decimal(catering.premium))"
            } else if segmentedControl.selectedSegmentIndex == 1 {
                textView.text = catering.basicInfo
                priceTextField.text = "\(Decimal(catering.basic))"
            }
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageCatringInfo()
        set()
    }
    
    // MARK: - Set
    
    private func set() {
        segmentedControl.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 50.0)
        segmentedControl.setLineForSegment()
        view.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50.0),
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 23.0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        textView.delegate = self
        scrollView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.heightAnchor.constraint(equalToConstant: 126.0),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22.0),
            view.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 34.0),
            textView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 23.0)
        ])
        view.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22.0),
            view.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 33.0)
        ])
        view.addSubview(priceTextField)
        NSLayoutConstraint.activate([
            priceTextField.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            priceTextField.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 4.0)
        ])
        priceTextField.addTarget(self, action: #selector(self.textFieldEditingChanged(_:)), for: .editingChanged)
        priceTextField.addTarget(self, action: #selector(editingEnded(_:)), for: .editingDidEnd)
        priceTextField.addTarget(self, action: #selector(editingDidEnter(_:)), for: .editingDidEndOnExit)
    }
    
    // MARK: - Actions
    
    @objc func segmentChange(_ sender: UISegmentedControl) {
        sender.animateLineForSegment()
        UIView.animate(withDuration: 0.4) { [unowned self] in
            self.scrollView.contentOffset.x = CGFloat(self.view.bounds.width * CGFloat(sender.selectedSegmentIndex))
        }
        manageCatringInfo()
    }
    
    @objc func editingEnded(_ sender: Any) {
        editCatering()
    }
    
    @objc private func editingDidEnter(_ sender: Any) {
        editCatering()
    }
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        if segmentedControl.selectedSegmentIndex == 0 {
            catering.premium = Double("\(sender.text ?? "0")") ?? 0
        } else if segmentedControl.selectedSegmentIndex == 1 {
            catering.basic = Double("\(sender.text ?? "0")") ?? 0
        }
    }

}

// MARK: - Text View Delegate

extension CateringViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if segmentedControl.selectedSegmentIndex == 0 {
            catering.premiumInfo = textView.text
        } else if segmentedControl.selectedSegmentIndex == 1 {
            catering.basicInfo = textView.text
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        editCatering()
    }
}

// MARK: - Web Services

extension CateringViewController {
    private func manageCatringInfo() {
        FirebaseManager.shared.catering { self.catering = $0 }
    }
    
    private func editCatering() {
        FirebaseManager.shared.catering(pricing: catering) { error in
            if let error = error {
                self.showError(title: "", message: error.localizedDescription)
            } else {
//                self.flowController.showSuccess(success: .updatedCateringInfo)
            }
        }
    }
}

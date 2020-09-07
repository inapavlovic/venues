//
//  RateViewController.swift
//  vennu
//
//  Created by Ina Statkic on 15.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class RateViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var starButtons: [UIButton]!
    
    // MARK: - Properties
    
    var review: String?
    var venue: Venue!
    var rating = 0 {
        didSet {
            for (index, button) in starButtons.enumerated() {
                button.isSelected = index < rating
            }
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        set()
        textView.delegate = self
    }

    // MARK: - Set
    
    private func set() {
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.aluminum.cgColor
        containerView.layer.cornerRadius = 20
        textLabel.lineSpacing(5)
        textLabel.textAlignment = .center
        for button in starButtons {
            button.addTarget(self, action: #selector(tapStarButton(button:)), for: .touchUpInside)
            button.setImage(UIImage(named: "rate.star.fill"), for: [.selected, .highlighted])
        }
    }
    
    // MARK: - Actions
    
    @IBAction func rate(_ sender: Any) {
        if let review = review {
            write(review: review)
        }
        if rating > 0 {
            star()
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func tapStarButton(button: UIButton) {
        guard let index = starButtons.firstIndex(of: button) else { return }
        rating = index + 1
    }
}

// MARK: - Text View Delegate

extension RateViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        review = textView.text
    }
}

// MARK: - Web Services

extension RateViewController {
    private func star() {
        FirebaseManager.shared.rate(rating, venue: venue.id) { error in
            if let error = error {
                debugPrint(error)
            }
        }
    }
    private func write(review: String) {
        FirebaseManager.shared.write(review: review, venue: venue.id) { error in
            if let error = error {
                debugPrint(error)
            }
        }
    }
}

//
//  BookingDetailsInfoView.swift
//  vennu
//
//  Created by Ina Statkic on 15/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class BookingDetailsView: UIView {
    
    // MARK: Outlets
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var numberOfPeopleLabel: UILabel!
    @IBOutlet private weak var cateringLabel: UILabel!
    @IBOutlet private weak var customerLabel: UILabel!
    @IBOutlet private weak var customerStackView: UIStackView?
    @IBOutlet private weak var textView: UITextView!
    
    // MARK: - Properties
    
    var note: ((String) -> ())?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
        textView.delegate = self
    }
    
    // MARK: - Set
    
    private func setUI() {
        #if PRO
        textView.isEditable = false
        #elseif USER
        textView.isEditable = true
        customerStackView?.removeFromSuperview()
        #endif
    }
    
    // MARK: - Data
    
    var startDate: Date? {
        get {
            Date()
        }
        set {
            dateLabel.text = newValue?.dMMM()
        }
    }
    
    var startTime: String? {
        get {
            startTimeLabel.text
        }
        set {
            startTimeLabel.text = newValue
        }
    }
    
    var duration: String? {
        get {
            return durationLabel.text
        }
        set {
            durationLabel.text = newValue
        }
    }
    
    var catering: Catering? {
        get {
            Catering()
        }
        set {
            cateringLabel.text = "\(newValue?.premium ?? 0) Premium \(newValue?.basic ?? 0) Basic"
            numberOfPeopleLabel.text = "\((newValue?.basic ?? 0) + (newValue?.premium ?? 0)) People"
        }
    }
    
    #if PRO
    var customer: String? {
        get {
            return customerLabel.text
        }
        set {
            customerLabel.text = newValue
        }
    }
    #endif
    
    var notes: String? {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
        }
    }
    
}

// MARK: - Text View Delegate

extension BookingDetailsView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        note?(textView.text)
    }
}

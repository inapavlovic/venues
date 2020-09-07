//
//  BookViewController.swift
//  users
//
//  Created by Ina Statkic on 23/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

struct BookState {
    var startDate: Date = Date()
    var startTime: Int = 0
    var durationIndex: Int = 0
    var endDate: Date = Date()
    var cateringPrice: CateringPrice = CateringPrice()
}

final class BookViewController: UIViewController {
    
    // MARK: Flow
    
    lazy var flowController = BookFlowController(self)
    
    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var blurView: UIView!
    @IBOutlet private weak var basicCateringStepper: UIStepper!
    @IBOutlet private weak var premiumCateringStepper: UIStepper!
    @IBOutlet private weak var basicNumOfPeopleLabel: UILabel!
    @IBOutlet private weak var premiumNumOfPeopleLabel: UILabel!
    @IBOutlet private weak var durationPickerView: UIPickerView!
    @IBOutlet private weak var startTimePickerView: UIPickerView!
    @IBOutlet private weak var datePickerView: UIPickerView!
    
    // MARK: - Properties
    
    var venue: Venue! {
        didSet {
            booking.title = venue.title
            booking.venueId = venue.id
            booking.uidVenue = venue.uid
        }
    }
    let calendar = Calendar.current
    var state = BookState() {
        didSet {
            state.startDate = calendar.date(bySettingHour: state.startTime, minute: 0, second: 0, of: state.startDate)!
            state.endDate = calendar.date(bySettingHour: state.startTime, minute: 0, second: 0, of: state.endDate)!
            state.endDate = Duration.end(date: state.startDate)[state.durationIndex]

            booking.startDate = state.startDate.time()?.timeIntervalSince1970
            booking.endDate = state.endDate.time()?.timeIntervalSince1970
            booking.cateringPrice = state.cateringPrice.basic + state.cateringPrice.premium
        }
    }
    var booking = Booking()
    var cateringPrice = CateringPrice()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        setPickers()
        setSteppers()
        catering()
        fee()
    }
    
    // MARK: - Set
    
    private func setSteppers() {
        basicNumOfPeopleLabel.text = "\(Int(basicCateringStepper.value))"
        premiumNumOfPeopleLabel.text = "\(Int(premiumCateringStepper.value))"
        basicCateringStepper.addTarget(self, action: #selector(stepperValueDidChange(_:)), for: .valueChanged)
        premiumCateringStepper.addTarget(self, action: #selector(stepperValueDidChange(_:)), for: .valueChanged)
        basicCateringStepper.maximumValue = Double(venue.capacity.numberOfPeople)
        premiumCateringStepper.maximumValue = Double(venue.capacity.numberOfPeople)
    }
    
    private func setPickers() {
        [durationPickerView, startTimePickerView, datePickerView].forEach {
            $0?.delegate = self
            $0?.dataSource = self
        }
        durationPickerView.selectRow(4, inComponent: 0, animated: true)
        pickerView(durationPickerView, didSelectRow: 4, inComponent: 0)
        startTimePickerView.selectRow(state.startTime, inComponent: 0, animated: true)
        pickerView(startTimePickerView, didSelectRow: state.startTime, inComponent: 0)
        datePickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView(datePickerView, didSelectRow: 0, inComponent: 0)
    }
    
    // MARK: - Actions
    
    @objc func stepperValueDidChange(_ stepper: UIStepper) {
        switch stepper {
        case basicCateringStepper:
            basicNumOfPeopleLabel.text = "\(Int(stepper.value))"
            booking.catering?.basic = Int(stepper.value)
            state.cateringPrice.basic = cateringPrice.basic * stepper.value
        case premiumCateringStepper:
            premiumNumOfPeopleLabel.text = "\(Int(stepper.value))"
            booking.catering?.premium = Int(stepper.value)
            state.cateringPrice.premium = cateringPrice.premium * stepper.value
        default: break
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func apply(_ sender: Any) {
        let vc = BookingDetailsViewController.instantiate(storyboard: "BookingDetails")
        vc.booking = self.booking
        let nc = ListNavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        nc.modalTransitionStyle = .crossDissolve
        let presentingViewController = self.presentingViewController
        dismiss(animated: true) {
            presentingViewController?.present(nc, animated: true)
        }
    }
    
    @IBAction func basicInfo(_ sender: Any) {
        flowController.showInfo(context: InfoContext.basic)
    }
    
    @IBAction func premiumInfo(_ sender: Any) {
        flowController.showInfo(context: InfoContext.premium)
    }
    
}

// MARK: - Picker View Data Source

extension BookViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case durationPickerView: return Duration.all.count
        case startTimePickerView: return Time.all.count
        case datePickerView: return 2
        default: return 1
        }
    }
}

// MARK: - Picker View Delegate

extension BookViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 20))
        label.textAlignment = .right
        label.textColor = .tuna
        label.font = .systemFont(ofSize: 14)
        switch pickerView {
        case durationPickerView:
            label.text = Duration.all[row]
        case startTimePickerView:
            label.text = Time.all[row]
        case datePickerView:
            label.text = [Date(), calendar.date(byAdding: .day, value: 1, to: Date())!][row].dMMM().uppercased()
        default: return label
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.bounds.width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.subviews.last?.backgroundColor = .clear
        switch pickerView {
        case durationPickerView:
            booking.duration = Duration.type(pricing: venue.pricing)[row].name
            booking.rentPrice = Duration.price(pricing: venue.pricing)[row]
            state.endDate = Duration.end(date: state.startDate)[row]
            state.durationIndex = Duration.index[row]
        case startTimePickerView:
            state.startTime = Time.index[row] + 1
            booking.startTime = Time.all[row]
        case datePickerView:
            state.startDate = [Date(), calendar.date(byAdding: .day, value: 1, to: Date())!][row]
        default: break
        }
    }
}

// MARK: - Web Services

extension BookViewController {
    private func catering() {
        FirebaseManager.shared.catering { self.cateringPrice = $0 }
    }
    private func fee() {
        FirebaseManager.shared.fee { value in
            if let value = value {
                self.booking.fee = value
            }
        }
    }
}

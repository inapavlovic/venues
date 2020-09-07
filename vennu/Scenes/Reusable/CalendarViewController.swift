//
//  CalendarViewController.swift
//  vennu
//
//  Created by Ina Statkic on 11.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import HorizonCalendar

final class CalendarViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayYearLabel: UILabel!
    @IBOutlet weak var listViewHeight: NSLayoutConstraint!
    @IBOutlet weak var listView: UIView!
    
    // MARK: - Properties
    
    private lazy var calendar = Calendar.current
    private lazy var calendarView = CalendarView(initialContent: makeContent())
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "AVAILABILITY"
        setNavigation()
        set()
        setElements()
        calendarView.daySelectionHandler = { [weak self] day in
            if let date = self?.calendar.date(from: DateComponents(year: day.components.year, month: day.components.month, day: day.components.day)) {
                self?.monthLabel.text = date.monthLLLL().uppercased()
                self?.dayYearLabel.text = date.ddyyyy()
            }
        }
    }
    
    // MARK: - Elements
    
    let child = ItemsViewController<String, TimeCell>()
    
    // MARK: - Actions
    
    private func makeContent() -> CalendarViewContent {
        calendar.firstWeekday = 2
        let startDate = calendar.date(from: DateComponents(year: 2020, month: 12, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: 2040, month: 12, day: 31))!
        
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular ? .horizontal(monthWidth: view.frame.width - (view.layoutMargins.left + view.layoutMargins.right) - 56) : .horizontal(monthWidth: view.frame.width - 360)
        )
        .withDayItemModelProvider { day in
            CalendarItemModel<DayLabel>(invariantViewProperties: .init(font: .systemFont(ofSize: 14), textColor: .doveGray, backgroundColor: .clear), viewModel: .init(day: day)
            )
        }
        .withMonthDayInsets(UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        .withInterMonthSpacing(30)
        .withMonthHeaderItemModelProvider { month in
            CalendarItemModel<MonthLabel>(invariantViewProperties: .init(font: .systemFont(ofSize: 12), textColor: .coralRed), viewModel: .init(month: month))
        }
        .withDayOfWeekItemModelProvider { (month, number) in
            CalendarItemModel<DayOfWeekLabel>(invariantViewProperties: .init(font: .systemFont(ofSize: 10), textColor: .pumice), viewModel: .init(month: month!, dayOfWeekPosition: number))
        }
        .withOverlayItemModelProvider(for: [.day(containingDate: Date()), .day(containingDate: calendar.date(from: DateComponents(year: 2020, month: 12, day: 12))!)]) { overlayLayoutContext in
            CalendarItemModel<MarkDayView>(invariantViewProperties: .init(), viewModel: .init(frameOfItem: overlayLayoutContext.overlaidItemFrame, color: self.setColor(to: overlayLayoutContext.overlaidItemLocation)))
            }
    }
    
    @objc private func back() {
        dismiss(animated: true)
    }
    
    // MARK: - Set
    
    private func setElements() {
        child.items = ["09:00 - 10:00 AM", "13:00 - 14:00 PM"]
        child.configure = { $1.textLabel?.text = $0.uppercased() }
        embed(child, into: listView) { child, parent in
            NSLayoutConstraint.activate([
                child.topAnchor.constraint(equalTo: parent.topAnchor),
                child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular || traitCollection.verticalSizeClass == .compact ? 0 : 164),
                parent.trailingAnchor.constraint(equalTo: child.trailingAnchor, constant: traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular || traitCollection.verticalSizeClass == .compact ? 0 : 164),
                child.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
            ])
        }
        child.tableView.rowHeight = 26
    }
    
    private func setColor(to location: CalendarViewContent.OverlaidItemLocation) -> UIColor {
        let str = "\(location)"
        if str.contains("2020-12-14") {
            return Legend.fullDay.color
        } else {
            return Legend.fewHours.color
        }
    }
    
    private func set() {
        calendarView.layer.cornerRadius = 15.0
        calendarView.layer.shadowRadius = 14.0
        calendarView.layer.shadowOpacity = 0.06
        calendarView.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        view.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate([
                calendarView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
                view.layoutMarginsGuide.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: 10)
            ])
            if view.frame.height < 812 {
                calendarView.heightAnchor.constraint(equalToConstant: 315).isActive = true
                calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
            } else {
                calendarView.heightAnchor.constraint(equalToConstant: 368).isActive = true
                listViewHeight.constant = 130
                calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 54).isActive = true
            }
        } else if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate([
                calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 180),
                view.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: 180)
            ])
            calendarView.heightAnchor.constraint(equalToConstant: 540).isActive = true
            listViewHeight.constant = 200
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 74).isActive = true
        }

//        calendarView.subviews.first?.clipsToBounds = false
//        calendarView.scroll(toMonthContaining: Date(), scrollPosition: .centered, animated: true)
        calendarView.directionalLayoutMargins.leading = 0.0

        monthLabel.text = Date().monthLLLL().uppercased()
        dayYearLabel.text = Date().ddyyyy()
    }
}

// MARK: - Navigation

extension CalendarViewController {
    private func setNavigation() {
        let image = UIImage(systemName: "chevron.left" )?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .medium))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = .tuna
    }
}

//
//  SegmentedViewController.swift
//  vennu
//
//  Created by Ina Statkic on 05/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class SegmentedViewController: UIViewController {
    
    // MARK: Elements
    
    var segmentedControl = UISegmentedControl(items: Segment.allCases.map { $0.rawValue })
    
    var scrollView: UIScrollView!
    var emptyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 280, height: 100))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .tuna
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    #if USER
    private var segment0: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .coralRed
        view.layer.borderColor = UIColor.coralRed.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    private var segment1: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.borderColor = UIColor.coralRed.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [segment0, segment1])
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    #endif

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set()

    }
    
    #if PRO
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        segmentedControl.updateLineFrame()
    }
    #endif
    
    // MARK: - Set

    private func set() {
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.addTarget(self, action: #selector(segmentChange(_:)), for: .valueChanged)
        segmentedControl.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 44.0)
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        #if PRO
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.tuna, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.kern : 0.92], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.coralRed, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.kern : 0.92], for: .selected)
        segmentedControl.setLineForSegment()
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0).isActive = true
        #elseif USER
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.coralRed, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.kern : 0.92], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.kern : 0.92], for: .selected)
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0).isActive = true
        segmentedControl.insertSubview(stackView, at: 0)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: 2.0),
            stackView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 10),
        ])
        segment0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        #endif
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
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
        scrollView.clipsToBounds = false
        scrollView.isPagingEnabled = true
        
        emptyLabel.text = "No Upcoming Bookings"
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: emptyLabel.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: emptyLabel.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc func segmentChange(_ sender: UISegmentedControl) {
        #if PRO
        sender.animateLineForSegment()
        #endif
        UIView.animate(withDuration: 0.4) { [unowned self] in
            self.scrollView.contentOffset.x = CGFloat(self.view.bounds.width * CGFloat(sender.selectedSegmentIndex))
        }
        let title = segmentedControl.titleForSegment(at: sender.selectedSegmentIndex)
        if title == Segment.upcoming.rawValue {
            emptyLabel.text = "No Upcoming Bookings"
            #if USER
            segment0.backgroundColor = .coralRed
            segment1.backgroundColor = .clear
            #endif
        } else if title == Segment.past.rawValue {
            emptyLabel.text = "No Past Bookings"
            #if USER
            segment1.backgroundColor = .coralRed
            segment0.backgroundColor = .clear
            #endif
        }
    }
    
}

// MARK: - Scroll Delegate

extension SegmentedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        #if PRO
        guard let line = segmentedControl.viewWithTag(1) else { return }
        line.frame.origin.x = (segmentedControl.bounds.width / CGFloat(segmentedControl.numberOfSegments)) * (scrollView.contentOffset.x / view.frame.width)
        #endif
        if scrollView.contentOffset.x == 0 {
            segmentedControl.selectedSegmentIndex = 0
            emptyLabel.text = "No Upcoming Bookings"
            #if USER
            segment0.backgroundColor = .coralRed
            segment1.backgroundColor = .clear
            #endif
        } else if scrollView.contentOffset.x == view.frame.size.width {
            segmentedControl.selectedSegmentIndex = 1
            emptyLabel.text = "No Past Bookings"
            #if USER
            segment1.backgroundColor = .coralRed
            segment0.backgroundColor = .clear
            #endif
        }
    }
}

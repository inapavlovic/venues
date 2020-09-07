//
//  AvailabilityView.swift
//  vennu
//
//  Created by Ina Statkic on 12.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import HorizonCalendar

final class MarkDayView: UIView {
    
    private let backgroundLayer: CALayer

    init() {
        backgroundLayer = CALayer()
        super.init(frame: .zero)
        backgroundLayer.cornerRadius = 2.5
        layer.addSublayer(backgroundLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var color: CGColor {
        get { backgroundLayer.backgroundColor ?? UIColor.clear.cgColor }
        set { backgroundLayer.backgroundColor = newValue }
    }
    
    var frameOfItem: CGRect? {
       didSet {
         guard frameOfItem != oldValue else { return }
         setNeedsLayout()
       }
     }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let frameOfItem = frameOfItem else { return }
        let size = CGSize(width: 5, height: 5)

        let proposedFrame = CGRect(x: frameOfItem.midX - (size.width / 2), y: frameOfItem.maxY - 10, width: size.width, height: size.height)
        let frame: CGRect
        if proposedFrame.maxX > bounds.width {
            frame = proposedFrame.applying(.init(translationX: bounds.width - proposedFrame.maxX, y: 0))
        } else if proposedFrame.minX < 0 {
            frame = proposedFrame.applying(.init(translationX: -proposedFrame.minX, y: 0))
        } else {
            frame = proposedFrame
        }
        backgroundLayer.frame = frame
    }

}

extension MarkDayView: CalendarItemViewRepresentable {
    
    /// Properties that are set once when we initialize the view.
    struct InvariantViewProperties: Hashable {
    }
    
    /// Properties that will vary depending on the particular date being displayed.
    struct ViewModel: Equatable {
        let frameOfItem: CGRect?
        let color: UIColor
    }

    static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> MarkDayView {
        MarkDayView()
    }
    
    static func setViewModel(_ viewModel: ViewModel, on view: MarkDayView) {
        view.frameOfItem = viewModel.frameOfItem
        view.backgroundLayer.backgroundColor = viewModel.color.cgColor
    }

}

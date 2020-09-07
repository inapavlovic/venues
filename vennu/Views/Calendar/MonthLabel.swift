//
//  MonthLabel.swift
//  vennu
//
//  Created by Ina Statkic on 12.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import HorizonCalendar

struct MonthLabel: CalendarItemViewRepresentable {

  /// Properties that are set once when we initialize the view.
  struct InvariantViewProperties: Hashable {
    let font: UIFont
    let textColor: UIColor
  }

  /// Properties that will vary depending on the particular date being displayed.
  struct ViewModel: Equatable {
    let month: Month
  }

  static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> UILabel
  {
    let label = UILabel()
    label.numberOfLines = 2
    let line = UIView()
    line.backgroundColor = .gallery
    line.frame = CGRect(x: 0, y: 46, width: 400, height: 1)
    label.addSubview(line)
    label.font = invariantViewProperties.font
    label.textColor = invariantViewProperties.textColor
    return label
  }

  static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("LLLLyyyy")
    let calendar = Calendar.current
    let date = calendar.date(from: DateComponents(year: viewModel.month.components.year, month: viewModel.month.components.month))!
    view.text = "\n    \(dateFormatter.string(from: date).uppercased())"
  }

}

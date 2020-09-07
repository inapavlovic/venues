//
//  DayLabel.swift
//  vennu
//
//  Created by Ina Statkic on 11.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import HorizonCalendar

struct DayLabel: CalendarItemViewRepresentable {

  /// Properties that are set once when we initialize the view.
  struct InvariantViewProperties: Hashable {
    let font: UIFont
    let textColor: UIColor
    let backgroundColor: UIColor
  }

  /// Properties that will vary depending on the particular date being displayed.
  struct ViewModel: Equatable {
    let day: Day
  }

  static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> UILabel
  {
    let label = UILabel()
    label.backgroundColor = invariantViewProperties.backgroundColor
    label.font = invariantViewProperties.font
    label.textColor = invariantViewProperties.textColor
    label.textAlignment = .center
    return label
  }

  static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("dd")
    let date = calendar.date(from: DateComponents(day: viewModel.day.components.day))!
    view.text = dateFormatter.string(from: date)
  }

}

//
//  WeekDayLabel.swift
//  vennu
//
//  Created by Ina Statkic on 12.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import HorizonCalendar

struct DayOfWeekLabel: CalendarItemViewRepresentable {

  /// Properties that are set once when we initialize the view.
  struct InvariantViewProperties: Hashable {
    let font: UIFont
    let textColor: UIColor
  }

  /// Properties that will vary depending on the particular day-of-week being displayed.
  struct ViewModel: Equatable {
    let month: Month
    let dayOfWeekPosition: Int
  }

  static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> UILabel
  {
    let label = UILabel()
    label.font = invariantViewProperties.font
    label.textColor = invariantViewProperties.textColor
    label.textAlignment = .center
    return label
  }

  static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("eeeeee")
    let date = calendar.date(from: DateComponents(weekday: viewModel.dayOfWeekPosition + 1, weekOfMonth: viewModel.month.components.month))!
    view.text = dateFormatter.string(from: date).uppercased()
  }

}

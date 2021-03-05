//
//  Date+Extensions.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/4/21.
//

import Foundation
import UIKit

extension Date {
    func chatDateFormatted() -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        // if the chat date is recent meaning today, dont display date, only time
        if calendar.isDateInToday(self) {
            formatter.dateFormat = "h:mm a"
        } else {
            formatter.dateFormat = "MMM d, yyyy h:mm a"
        }
        
        return formatter.string(from: self)
    }
}

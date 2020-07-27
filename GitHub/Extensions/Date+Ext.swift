//
//  Date+Ext.swift
//  GitHub
//
//  Created by Vlad on 7/27/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}

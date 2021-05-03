//
//  DateExtension.swift
//  themdb-nicholas-rodriguez
//
//  Created by Nicolás A. Rodríguez on 4/22/21.
//

import Foundation

extension DateFormatter {
    static func customBasicDateFormat(from string: String) -> String {
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inFormatter.date(from: string) else {
            return ""
        }
        
        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "MMMM dd, yyyy"
        return outFormatter.string(from: date)
    }
}

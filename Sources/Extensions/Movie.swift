//
//  Movie.swift
//  Movix
//
//  Created by Viranaiken Jessy on 27/10/25.
//

import Foundation
import TMDb

extension Movie {
    
        func getFormattedBudget() -> String? {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            return formatter.string(from: NSNumber(value: self.budget ?? 0)) ?? "N/A"
    }
    
}

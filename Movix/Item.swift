//
//  Item.swift
//  Movix
//
//  Created by Jessy Viranaiken on 16/12/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

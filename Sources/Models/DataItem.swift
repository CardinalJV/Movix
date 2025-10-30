//
//  Item.swift
//  Movix
//
//  Created by Jessy Viranaiken on 16/12/2024.
//

import Foundation
import SwiftData

@Model
final class DataItem: Identifiable {
    var id = UUID()
    var targetId: Int
    
    init(targetId: Int) {
        self.targetId = targetId
    }
}

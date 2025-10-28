//
//  String.swift
//  Movix
//
//  Created by Viranaiken Jessy on 27/10/25.
//

import Foundation

extension String {
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

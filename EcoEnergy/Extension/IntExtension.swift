//
//  IntExtension.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//

import Foundation

extension Int {

    func addLeadingZeros(target: Int = 2) -> String {
        return String(repeating: "0", count: target - String(self).count) + String(self)
    }

}

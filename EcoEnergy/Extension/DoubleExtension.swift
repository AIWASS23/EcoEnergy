//
//  DoubleExtension.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//

import Foundation

extension Double {

    func addZeros(wholeNumTarget: Int = -1, fractionalTarget: Int = -1) -> String {
        let wholeNum: Int = Int(self)
        var wholeNumStr: String = String(wholeNum)
        if wholeNumTarget != -1 {
            wholeNumStr = String(repeating: "0", count: wholeNumTarget - String(wholeNum).count) + String(wholeNum)
        }
        let rawFractionalStr: String = String(self.description.split(separator: ".").last ?? "0")
        var fractionalStr: String = rawFractionalStr
        if fractionalTarget != -1 {
            fractionalStr = rawFractionalStr + String(repeating: "0", count: fractionalTarget - rawFractionalStr.count)
        }
        return "\(wholeNumStr).\(fractionalStr)"
    }
}

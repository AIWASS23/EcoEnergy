//
//  Process.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//

import Foundation

public class Processor {

    // Check if processor is arm64
    static func isArmProcessor() -> Bool {
        let cpuArchitecture: String = ProcessInfo.processInfo.machineHardwareName ?? "null"
        return cpuArchitecture == "arm64"
    }

    // Get processor core count
    static func getCoreCount() -> Int {
        if isArmProcessor() {
            // Return core count
            return ProcessInfo.processInfo.processorCount
        } else {
            // Return double for Intel hyper-threading
            return ProcessInfo.processInfo.processorCount * 2
        }
    }



}

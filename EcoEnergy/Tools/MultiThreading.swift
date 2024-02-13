//
//  MultiThreading.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//

import Foundation

class MultiThreading {

    static func parallelForEach(array: Array<Any>, action: (_ currElement: Any) -> Void) {
        DispatchQueue.concurrentPerform(iterations: array.count) { index in
            let currElement: Any = array[index]
            action(currElement)
        }
    }
}

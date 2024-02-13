//
//  ArrayExtension.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//

import Foundation

extension Array {

    func parallelMap<T>(_ transform: (Element) -> T) -> [T] {
        var result = Array<T?>(repeating: nil, count: count)
        let queue = DispatchQueue(label: "com.marceloDeAraujo.parallelMap", attributes: .concurrent)

        DispatchQueue.concurrentPerform(iterations: count) { i in
            let transformed = transform(self[i])
            queue.sync {
                result[i] = transformed
            }
        }

        return result.compactMap { $0 }
    }

}

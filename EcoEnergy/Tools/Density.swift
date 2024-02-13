//
//  Density.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//

import Foundation

class Density<Value: Hashable> {

    var id: [UUID]
    var data: [Value]
    var label: [Value: String]

    init(id: [UUID], data: [Value])  {
        self.id = id
        self.data = data
        self.label = [Value: String]()
        for point in self.data {
            self.label[point] = "undefined"
        }
    }

    func rangeQuery(distance: (Value, Value) -> Double, neighbour: Value, epsilon: Double) -> [Value] {
        var neighbors = [Value]()
        for point in self.data {
            if distance(neighbour, point) <= epsilon {
                neighbors.append(point)
            }
        }
        return neighbors
    }

    func cluster(distance: (Value, Value) -> Double, epsilon: Double, minPoints: Int) {

        var count: Int = 0

        for point in self.data {

            if self.label[point] != "undefined" {
                continue
            }

            var neighbours: [Value] = self.rangeQuery(distance: distance, neighbour: point, epsilon: epsilon)

            if neighbours.count < minPoints  {

                self.label[point] = "noise"
                continue
            }

            count += 1

            self.label[point] = "\(count)"

            for neighbour in neighbours {

                if self.label[neighbour] == "noise" {
                    self.label[neighbour] = "\(count)"
                }

                if self.label[neighbour] != "undefined" {
                    continue
                }

                label[neighbour] = "\(count)"

                let furtherNeighbours: [Value] = self.rangeQuery(distance: distance, neighbour: neighbour, epsilon: epsilon)

                if furtherNeighbours.count >= minPoints  {
                    neighbours.append(contentsOf:  furtherNeighbours)
                    continue
                }
            }
        }
    }
}

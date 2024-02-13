//
//  SequenceExtension.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//

import Foundation

extension Sequence {

    func asyncMap<T>(_ closure: @Sendable (Element) async throws -> T) async rethrows -> [T] {
        var array: [T] = []
        array.reserveCapacity(self.underestimatedCount)
        for element in self {
            array.append(try await closure(element))
        }
        return array
    }

    func concurrentMap<T, ID>(
        id identifyingClosure: (Element) -> ID,
        _ closure: @escaping @Sendable (Element) async throws -> T) async rethrows -> [T] where ID: Equatable {
            try await withThrowingTaskGroup(of: (value: T, id: ID).self) { group in
                let withIdentifiers = self.map({ (element: $0, id: identifyingClosure($0)) })
                for (element, id) in withIdentifiers {
                    group.addTask {
                        try await (value: closure(element), id: id)
                    }
                }
                var array: [(value: T, id: ID)] = []
                array.reserveCapacity(self.underestimatedCount)
                for try await valueWithId in group {
                    array.append(valueWithId)
                }
                array.sort(by: { lhs, rhs in
                    withIdentifiers.firstIndex(where: { $0.id == lhs.id })! <
                        withIdentifiers.firstIndex(where: { $0.id == rhs.id })!
                })
                return array.map(\.value)
            }
        }


    func all(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try !condition($0) }
    }

    func none(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try condition($0) }
    }

    func any(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        return try contains { try condition($0) }
    }

    func reject(where condition: (Element) throws -> Bool) rethrows -> [Element] {
        return try filter { return try !condition($0) }
    }

    func count(where condition: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self where try condition(element) {
            count += 1
        }
        return count
    }

    func forEachReversed(_ body: (Element) throws -> Void) rethrows {
        try reversed().forEach(body)
    }

    func forEach(where condition: (Element) throws -> Bool, body: (Element) throws -> Void) rethrows {
        try lazy.filter(condition).forEach(body)
    }

    func accumulate<U>(initial: U, next: (U, Element) throws -> U) rethrows -> [U] {
        var runningTotal = initial
        return try map { element in
            runningTotal = try next(runningTotal, element)
            return runningTotal
        }
    }

    func filtered<T>(_ isIncluded: (Element) throws -> Bool, map transform: (Element) throws -> T) rethrows -> [T] {
        return try lazy.filter(isIncluded).map(transform)
    }

    func single(where condition: (Element) throws -> Bool) rethrows -> Element? {
        var singleElement: Element?
        for element in self where try condition(element) {
            guard singleElement == nil else {
                singleElement = nil
                break
            }
            singleElement = element
        }
        return singleElement
    }

    func withoutDuplicates<T: Hashable>(transform: (Element) throws -> T) rethrows -> [Element] {
        var set = Set<T>()
        return try filter { try set.insert(transform($0)).inserted }
    }

    func divided(by condition: (Element) throws -> Bool) rethrows -> (matching: [Element], nonMatching: [Element]) {
        var matching = [Element]()
        var nonMatching = [Element]()

        for element in self {
            try condition(element) ? matching.append(element) : nonMatching.append(element)
        }
        return (matching, nonMatching)
    }

    func sorted<T>(by keyPath: KeyPath<Element, T>, with compare: (T, T) -> Bool) -> [Element] {
        return sorted { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    func sorted<T: Comparable, U: Comparable>(
        by keyPath1: KeyPath<Element, T>,
        and keyPath2: KeyPath<Element, U>
    ) -> [Element] {
        return sorted {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
        }
    }

    func sorted<T: Comparable, U: Comparable, V: Comparable>(
        by keyPath1: KeyPath<Element, T>,
        and keyPath2: KeyPath<Element, U>,
        and keyPath3: KeyPath<Element, V>
    ) -> [Element] {
        return sorted {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            if $0[keyPath: keyPath2] != $1[keyPath: keyPath2] {
                return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
            }
            return $0[keyPath: keyPath3] < $1[keyPath: keyPath3]
        }
    }

    func sum<T: AdditiveArithmetic>(for keyPath: KeyPath<Element, T>) -> T {
        return reduce(.zero) { $0 + $1[keyPath: keyPath] }
    }

    func first<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        return first { $0[keyPath: keyPath] == value }
    }
}

extension Sequence where Element: Equatable {
    func contains(_ elements: [Element]) -> Bool {
        return elements.allSatisfy { contains($0) }
    }
}

extension Sequence where Element: Hashable {

    func contains(_ elements: [Element]) -> Bool {
        let set = Set(self)
        return elements.allSatisfy { set.contains($0) }
    }

    func containsDuplicates() -> Bool {
        var set = Set<Element>()
        return contains { !set.insert($0).inserted }
    }

    func duplicates() -> [Element] {
        var set = Set<Element>()
        var duplicates = Set<Element>()
        forEach {
            if !set.insert($0).inserted {
                duplicates.insert($0)
            }
        }
        return Array(duplicates)
    }
}

extension Sequence where Element: AdditiveArithmetic {

    func sum() -> Element {
        return reduce(.zero, +)
    }
}


extension Sequence where Element: Equatable {
    func concurrentMap<T>(_ closure: @escaping @Sendable (Element) async throws -> T) async rethrows -> [T] {
        try await self.concurrentMap(id: { $0 }, closure)
    }
}

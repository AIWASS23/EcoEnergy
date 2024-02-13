//
//  StringExtension.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//


import Foundation

enum LanguageError: Error {
    case noLanguageIdentified
}

extension String {

    var isNumber: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789.")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }

    var lines: [String] {
        return self.components(separatedBy: .newlines)
    }

    func camelCaseToWords() -> String {
        return self
            .replacingOccurrences(of: "([a-z])([A-Z](?=[A-Z])[a-z]*)", with: "$1 $2", options: .regularExpression)
            .replacingOccurrences(of: "([A-Z])([A-Z][a-z])", with: "$1 $2", options: .regularExpression)
            .replacingOccurrences(of: "([a-z])([A-Z][a-z])", with: "$1 $2", options: .regularExpression)
            .replacingOccurrences(of: "([a-z])([A-Z][a-z])", with: "$1 $2", options: .regularExpression)
    }

    func index(_ i: Int) -> String.Index {
        if i >= 0 {
            return self.index(self.startIndex, offsetBy: i)
        } else {
            return self.index(self.endIndex, offsetBy: i)
        }
    }

    subscript(i: Int) -> Character? {
        if i >= count || i < -count {
            return nil
        }

        return self[index(i)]
    }

    subscript(r: Range<Int>) -> String {
        return String(self[index(r.lowerBound)..<index(r.upperBound)])
    }

    func wildcard(pattern: String) -> Bool {
        let pred = NSPredicate(format: "self LIKE %@", pattern)
        return !NSArray(object: self).filtered(using: pred).isEmpty
    }

    func strDominantLanguage() throws -> String {
        if let language = NSLinguisticTagger.dominantLanguage(for: self) {
            return language
        }
        throw LanguageError.noLanguageIdentified
    }

    func distanceDamerauLevenshtein(between target: String) -> Int {
        let selfCount = self.count
        let targetCount = target.count

        if self == target {
            return 0
        }
        if selfCount == 0 {
            return targetCount
        }
        if targetCount == 0 {
            return selfCount
        }

        var da: [Character: Int] = [:]

        var d = Array(repeating: Array(repeating: 0, count: targetCount + 2), count: selfCount + 2)

        let maxdist = selfCount + targetCount
        d[0][0] = maxdist
        for i in 1...selfCount + 1 {
            d[i][0] = maxdist
            d[i][1] = i - 1
        }
        for j in 1...targetCount + 1 {
            d[0][j] = maxdist
            d[1][j] = j - 1
        }

        for i in 2...selfCount + 1 {
            var db = 1

            for j in 2...targetCount + 1 {
                let k = da[target[j - 2]!] ?? 1
                let l = db

                var cost = 1
                if self[i - 2] == target[j - 2] {
                    cost = 0
                    db = j
                }

                let substition = d[i - 1][j - 1] + cost
                let injection = d[i][j - 1] + 1
                let deletion = d[i - 1][j] + 1
                let selfIdx = i - k - 1
                let targetIdx = j - l - 1
                let transposition = d[k - 1][l - 1] + selfIdx + 1 + targetIdx

                d[i][j] = Swift.min(
                    substition,
                    injection,
                    deletion,
                    transposition
                )
            }

            da[self[i - 2]!] = i
        }

        return d[selfCount + 1][targetCount + 1]
    }

    func distanceHamming(between target: String) -> Int {
        assert(self.count == target.count)

        return zip(self, target).filter { $0 != $1 }.count
    }

    func distanceJaroWinkler(between target: String) -> Double {
        var stringOne = self
        var stringTwo = target
        if stringOne.count > stringTwo.count {
            stringTwo = self
            stringOne = target
        }

        let stringOneCount = stringOne.count
        let stringTwoCount = stringTwo.count

        if stringOneCount == 0 && stringTwoCount == 0 {
            return 1.0
        }

        let matchingDistance = stringTwoCount / 2
        var matchingCharactersCount: Double = 0
        var transpositionsCount: Double = 0
        var previousPosition = -1

        for (i, stringOneChar) in stringOne.enumerated() {
            for (j, stringTwoChar) in stringTwo.enumerated() {
                if max(0, i - matchingDistance)..<min(stringTwoCount, i + matchingDistance) ~= j {
                    if stringOneChar == stringTwoChar {
                        matchingCharactersCount += 1
                        if previousPosition != -1 && j < previousPosition {
                            transpositionsCount += 1
                        }
                        previousPosition = j
                        break
                    }
                }
            }
        }

        if matchingCharactersCount == 0.0 {
            return 0.0
        }

        let commonPrefixCount = min(max(Double(self.commonPrefix(with: target).count), 0), 4)

        let jaroSimilarity = (matchingCharactersCount / Double(stringOneCount) + matchingCharactersCount / Double(stringTwoCount) + (matchingCharactersCount - transpositionsCount) / matchingCharactersCount) / 3

        let commonPrefixScalingFactor = 0.1

        return jaroSimilarity + commonPrefixCount * commonPrefixScalingFactor * (1 - jaroSimilarity)
    }

    func distanceLevenshtein(between target: String) -> Int {
        let selfCount = self.count
        let targetCount = target.count

        if self == target {
            return 0
        }
        if selfCount == 0 {
            return targetCount
        }
        if targetCount == 0 {
            return selfCount
        }

        var v0 = [Int](repeating: 0, count: targetCount + 1)
        var v1 = [Int](repeating: 0, count: targetCount + 1)
        
        for i in 0..<v0.count {
            v0[i] = i
        }

        for (i, selfCharacter) in self.enumerated() {
            v1[0] = i + 1

            for (j, targetCharacter) in target.enumerated() {
                let cost = selfCharacter == targetCharacter ? 0 : 1
                v1[j + 1] = Swift.min(
                    v1[j] + 1,
                    v0[j + 1] + 1,
                    v0[j] + cost
                )
            }

            for j in 0..<v0.count {
                v0[j] = v1[j]
            }
        }

        return v1[targetCount]
    }

    func distanceMostFreqK(between target: String, K: Int, maxDistance: Int = 10) -> Int {
        return maxDistance - mostFrequentKSimilarity(
            characterFrequencyHashOne: self.mostFrequentKHashing(K),
            characterFrequencyHashTwo: target.mostFrequentKHashing(K)
        )
    }

    func distanceNormalizedMostFrequentK(between target: String, k: Int) -> Double {
        let selfMostFrequentKHash = self.mostFrequentKHashing(k)
        let targetMostFrequentKHash = target.mostFrequentKHashing(k)
        let commonCharacters = Set(selfMostFrequentKHash.keys).intersection(Set(targetMostFrequentKHash.keys))

        guard commonCharacters.isEmpty == false else {
            return 0.0
        }

        let similarity = commonCharacters.reduce(0) { characterCountSum, character -> Int in
            characterCountSum + selfMostFrequentKHash[character]! + targetMostFrequentKHash[character]!
        }

        return Double(similarity) / Double(self.count + target.count)
    }

    func mostFrequentKHashing(_ k: Int) -> [Character: Int] {
        let characterFrequencies = self.reduce(into: [Character: Int]()) { characterFrequencies, character in
            characterFrequencies[character] = (characterFrequencies[character] ?? 0) + 1
        }

        let sortedFrequencies = characterFrequencies.sorted { (characterFrequencies1, characterFrequencies2) -> Bool in
            if characterFrequencies1.value == characterFrequencies2.value {
                return self.firstIndex(of: characterFrequencies1.key)! < self.firstIndex(of: characterFrequencies2.key)!
            }
            return characterFrequencies1.value > characterFrequencies2.value
        }
        let clampedK = min(k, sortedFrequencies.count)

        return sortedFrequencies[0..<clampedK].reduce(into: [Character: Int]()) { mostFrequentKHash, characterFrequencyPair in
            mostFrequentKHash[characterFrequencyPair.key] = characterFrequencyPair.value
        }
    }

    func mostFrequentKSimilarity(characterFrequencyHashOne: [Character: Int], characterFrequencyHashTwo: [Character: Int]) -> Int {

        let commonCharacters = Set(characterFrequencyHashOne.keys).intersection(Set(characterFrequencyHashTwo.keys))

        guard commonCharacters.isEmpty == false else {
            return 0
        }

        return commonCharacters.reduce(0) { characterCountSum, character -> Int in
            characterCountSum + characterFrequencyHashOne[character]!
        }
    }
}

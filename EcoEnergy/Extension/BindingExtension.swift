//
//  BindingExtension.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//

import SwiftUI

extension Binding where Value: MutableCollection, Value: RangeReplaceableCollection, Value.Element: Identifiable {

    func filter(_ isIncluded: @escaping (Value.Element)->Bool) -> Binding<[Value.Element]> {
        return Binding<[Value.Element]>(
            get: {
                self.wrappedValue.filter(isIncluded)
            },
            set: { newValue in
                newValue.forEach { newItem in
                    guard let i = self.wrappedValue.firstIndex(where: { $0.id == newItem.id }) else {
                        self.wrappedValue.append(newItem)
                        return
                    }
                    self.wrappedValue[i] = newItem
                }
            }
        )
    }

}

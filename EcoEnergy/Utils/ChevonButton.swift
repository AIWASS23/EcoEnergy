//
//  ChevonButton.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//

import SwiftUI

struct ChevronButton: View {

    init(direction: ArrowDirection) {
        self.direction = direction
    }

    var direction: ArrowDirection

    var body: some View {
        Circle()
            .frame(width: 30)
            .foregroundStyle(.secondary)
            .overlay {
                Image(systemName: "chevron.\(direction.rawValue)")
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.white)
            }
            .border(Color.black)
    }

}

enum ArrowDirection: String, CaseIterable {
    case up, down, left, right
}


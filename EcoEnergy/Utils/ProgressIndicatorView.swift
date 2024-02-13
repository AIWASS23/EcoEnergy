//
//  ProgressIndicatorView.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//


import SwiftUI

struct ProgressIndicatorView: View {

    init(
        arr: [Any],
        switchOnTap: Bool = true,
        index: Binding<Int>
    ) {
        self.arr = arr
        self.switchOnTap = switchOnTap
        self._index = index
    }

    var arr: [Any]
    var switchOnTap: Bool
    @Binding var index: Int

    var body: some View {
        HStack(spacing: 7) {
            ForEach(0..<arr.count, id: \.self) { currIndex in
                Circle()
                    .frame(width: 10)
                    .foregroundStyle(Color.white)
                    .scaleEffect(index == currIndex ? 1.4 : 1.0)
                    .onTapGesture {
                        if switchOnTap {
                            withAnimation(.spring()) {
                                index = currIndex
                            }
                        }
                    }

            }
        }
        .padding(6)
        .background(Capsule().foregroundStyle(Color.gray))
    }
}

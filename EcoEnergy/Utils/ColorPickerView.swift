//
//  ColorPickerView.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//


import SwiftUI

@available(iOS 16, macOS 13.0, *)
struct ColorPickerView: View {

    init(
        colors: [Color] = [
            Color.red,
            Color.orange,
            Color.green,
            Color.blue,
            Color.purple,
            Color.pink
        ],
        lineColor: Binding<Color>
    ) {
        self.colors = colors
        self._lineColor = lineColor
    }

    var colors: [Color] = [
        Color.red,
        Color.orange,
        Color.green,
        Color.blue,
        Color.purple,
        Color.pink
    ]
    @Binding var lineColor: Color

    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                Image(systemName: lineColor == color ? Constants.Icons.recordCircleFill : Constants.Icons.circleFill)
                    .foregroundStyle(color)
                    .font(.system(size: 19))
                    .background(Circle().foregroundStyle(Color.white))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        lineColor = color
                    }
            }

        }
        .padding(5)
        .background {
            RoundedRectangle(cornerRadius: 11)
                .foregroundStyle(Color.secondary)
                .opacity(0.7)
        }
    }
}

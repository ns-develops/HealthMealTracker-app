//
//  ColorExtensions.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-05-08.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        var hexInt: UInt64 = 0
        if hexSanitized.hasPrefix("#") {
            let start = hexSanitized.index(hexSanitized.startIndex, offsetBy: 1)
            let hexSubstring = String(hexSanitized[start...])
            Scanner(string: hexSubstring).scanHexInt64(&hexInt)
        }
        
        let red = Double((hexInt & 0xFF0000) >> 16) / 255.0
        let green = Double((hexInt & 0x00FF00) >> 8) / 255.0
        let blue = Double(hexInt & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

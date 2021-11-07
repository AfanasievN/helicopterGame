//
//  Pixel.swift
//  Helicopter
//
//  Created by Nichita Afanasiev on 07.11.2021.
//

import SwiftUI

struct Pixel: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Rectangle()
            .frame(width: size, height: size)
            .foregroundColor(color)
    }
}

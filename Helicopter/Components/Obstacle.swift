//
//  Obstacle.swift
//  Helicopter
//
//  Created by Nichita Afanasiev on 07.11.2021.
//

import SwiftUI

struct Obstacle: View {
    let width: CGFloat = 20
    let height: CGFloat = 200
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .foregroundColor(Color.accentColor)
    }
}

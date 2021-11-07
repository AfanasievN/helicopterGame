//
//  ContentView.swift
//  Helicopter
//
//  Created by Nichita Afanasiev on 07.11.2021.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ContentView: View {
    
    @State private var heliPosition = CGPoint(x: 100, y: 100)
    @State private var obstPosition = CGPoint(x: 1000, y: 300)
    @State private var isPaused: Bool = false
    @State private var score = 0
    
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Helicopter()
                    .position(self.heliPosition)
                    .onReceive(timer) {_ in
                        self.gravity()
                    }
                
                Obstacle()
                    .position(self.obstPosition)
                    .onReceive(self.timer) {_ in
                            self.obstMove()
                    }
                
                Text("Score: \(self.score)")
                    .foregroundColor(Color.white)
                    .position(x: geo.size.width - 100, y: geo.size.height / 10)
                
                self.isPaused ? Button("Restart") {
                    self.resume()
                }.buttonStyle(GrowingButton()) : nil
                
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(self.isPaused ? Color.red : Color.black)
            .gesture(
                TapGesture()
                    .onEnded {
                        if !self.isPaused {
                            withAnimation {
                              self.heliPosition.y -= 100
                            }
                        }
                    }
            )
            .onReceive(self.timer) {_ in
                self.collisionDetection()
                self.score += 1
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    func gravity() {
        withAnimation {
            self.heliPosition.y += 20
        }
    }
    
    func obstMove() {
        if self.obstPosition.x > 0 {
            withAnimation {
                self.obstPosition.x -= 20
            }
        } else {
            self.obstPosition.x = 1000
            self.obstPosition.y = CGFloat.random(in: 0...500)
        }
    }
    
    func pause() {
        self.timer.upstream.connect().cancel()
    }
    
    func resume() {
        self.timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        self.obstPosition.x = 1000 // restart obst position
        self.heliPosition = CGPoint(x: 100, y: 100)
        
        self.isPaused = false
        self.score = 0
    }
    
    func collisionDetection() {
        if abs(heliPosition.x - obstPosition.x) < 25 + 10 && abs(heliPosition.y - obstPosition.y) < (25 + 100) {
            self.pause()
            self.isPaused = true
        }
    }
}

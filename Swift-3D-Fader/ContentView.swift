//
//  ContentView.swift
//  Swift-3D-Fader
//
//  Created by Eddy Salzmann on 26.11.20.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    var body: some View {
        
        ZStack{
            Swift3DFader(start: 0,width: 552/2.2,height: 1403/2.2, minVal: 0, maxVal: 399, speed: 1)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .edgesIgnoringSafeArea(.all)
    }
}

struct Swift3DFader : View{
    
    // Init values
    var start: Int
    var width: CGFloat
    var height: CGFloat
    var minVal: Int
    var maxVal: Int
    var speed: Double
    
    // Global values
    @State private var index = 0
    @State private var lastX : CGFloat = 0
    @State private var lastY : CGFloat = 0

    private let images = (0...399).map { UIImage(named: "fader_\($0).jpg")! }
    
    // Handle drag rotate
    var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged {value in
                
                // Vertical movement
                if value.translation.height > lastY {
                    
                    if index - Int(Double(value.translation.height - lastY) * speed) >= minVal {
                        index -= Int(Double(value.translation.height - lastY) * speed)
                    }
                }else{
                    if index + Int(Double(lastY - value.translation.height) * speed) <= maxVal {
                        index += Int(Double(lastY - value.translation.height) * speed)
                    }
                }

                lastY = value.translation.height
                lastX = value.translation.width
            }
            .onEnded { value in
                lastX = 0
                lastY = 0
            }
    }
    
    
    // Output
    var body: some View {

        Image(uiImage: images[index])
            .resizable()
            .frame(width: width, height: height, alignment: .center)
            .gesture(drag)
            .onAppear{
                if start <= maxVal && start >= minVal {
                    index = start
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

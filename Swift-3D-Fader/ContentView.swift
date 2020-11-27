//
//  ContentView.swift
//  Swift-3D-Fader
//
//  Created by Eddy Salzmann on 26.11.20.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State var screenWidth : CGFloat = 100
    @State var screenHeight : CGFloat = 100
    
    @State var screenWidth2 : CGFloat = 100
    @State var screenHeight2 : CGFloat = 100
    
    @State private var  isReady = false
    @State var opacity = 1.0
    
    var body: some View {
        
        ZStack{
            if self.isReady {
                ZStack{
                    Image("bgd")
                        .resizable()
                        .frame(width: screenWidth, height: screenHeight, alignment: .center)
                        .offset(y: -95)
                    
                    Swift3DFader(start: 0,width: 552/2.2,height: 1403/2.2, minVal: 0, maxVal: 399, speed: 1)
                    
                    
                }
            } else {
                Image("Intro")
                    .resizable()
                    .frame(width: screenWidth2, height: screenHeight2, alignment: .center)
                    .opacity(opacity)
                
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation{
                    opacity = 0
                    isReady = true
                }
            }
            screenWidth = UIScreen.main.bounds.width + 30
            screenHeight = screenWidth * (1947/900)
            
            screenWidth2 = UIScreen.main.bounds.width
            screenHeight2 = screenWidth * (1947/900)
        }
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
    
    @State var timer = LoadingTimer()
    
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
            .onReceive(
                
                timer.publisher,
                perform: { _ in
                    index += 1
                    if index >= 51 { index = 0 }
                }
            )
            .onAppear{
                if start <= maxVal && start >= minVal {
                    index = start
                }
                //self.timer.start()
                
                
            }
    }
}

class LoadingTimer {

    let publisher = Timer.publish(every: 0.1, on: .main, in: .default)
    private var timerCancellable: Cancellable?

    func start() {
        self.timerCancellable = publisher.connect()

    }

    func cancel() {
        self.timerCancellable?.cancel()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

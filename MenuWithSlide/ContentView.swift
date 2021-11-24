//
//  ContentView.swift
//  MenuWithSlide
//
//  Created by Evgeny on 22.11.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var isHidden: Bool = true
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
            Button {
                isHidden = false
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .frame(width: 30, height: 25)
                    .padding()
            }
        }
        .overlay(AreaWithGesture(isHidden: $isHidden))
    }
}

struct AreaWithGesture: View {
    @Binding var isHidden: Bool
    
    @State private var offsetX: CGFloat = 0
    @State private var isAppeared: Bool = false
    @State private var proxySizeWidth: CGFloat = 0
    
    private let offsetAnimation = Animation.easeIn(duration: 0.5)
    
    var body: some View {
        if !isHidden {
            GeometryReader { proxy in
                ZStack {
                    Color.black.opacity(isAppeared ? 0.2 : 0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            slideOut()
                        }
                    if isAppeared {
                        HStack {
                            Spacer()
                            MenuView()
                                .frame(width: proxy.size.width * 0.85, height: proxy.size.height)
                                .offset(x: offsetX)
                                .gesture(setupDragGesture())
                        }.onAppear {
                            proxySizeWidth = proxy.size.width
                            offsetX = proxy.size.width
                            slideIn()
                        }
                    }
                } // end of ZStack
            } // GeometryReader
            .onAppear {
                withAnimation {
                    isAppeared = true
                }
            }
        }
    }
    
    func setupDragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                if value.translation.width > 0 {
                    offsetX = value.translation.width
                }
            }
            .onEnded { _ in
                if offsetX < 100 {
                    slideIn()
                } else {
                    slideOut()
                }
            }
    }
    
    private func slideOut() {
        withAnimation(offsetAnimation) {
            offsetX = proxySizeWidth
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isHidden = true
            }
        }
    }
    
    private func slideIn() {
        withAnimation(offsetAnimation) {
            offsetX = 0
        }
    }
}

struct MenuView: View {
    var body: some View {
        ZStack {
            Color.purple.contrast(0.5)
            Text("This is menu view")
        }
    }
}

struct ViewWithDragGesture_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

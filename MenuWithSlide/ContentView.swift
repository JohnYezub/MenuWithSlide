//
//  ContentView.swift
//  MenuWithSlide
//
//  Created by Evgeny on 22.11.2021.
//

import SwiftUI

struct AreaWithGesture: View {
    @State private var valueX: CGFloat = 0
    @State private var isShown = false
    private let offsetAnimation = Animation.easeIn(duration: 0.5)
    private let timerInterval = TimeInterval(0.6)

    var body: some View {
        ZStack(alignment: .topTrailing) {

            Button {
                withAnimation(offsetAnimation) {
                    isShown = true
                }
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .frame(width: 30, height: 25)
            }
            .padding()

            GeometryReader { proxy in
                ZStack {
                    // Background view
                    Color.black.opacity(isShown ? 0.5 : 0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(offsetAnimation) {
                                valueX = proxy.size.width
                                DispatchQueue.main.asyncAfter(deadline: .now() + timerInterval) {
                                    isShown = false
                                }
                            }
                        }

                    if isShown {
                        let dragGesture = DragGesture()
                            .onChanged { value in
                                if value.translation.width > 0 {
                                    valueX = value.translation.width
                                }
                            }
                            .onEnded { _ in
                                withAnimation(offsetAnimation) {
                                    if valueX < proxy.size.width / 2 {
                                        valueX = 0
                                    } else {
                                        valueX = proxy.size.width
                                        DispatchQueue.main.asyncAfter(deadline: .now() + timerInterval) {
                                            isShown = false
                                        }
                                    }
                                }
                            }

                        // The menu view
                        HStack {
                            Spacer()
                            Color.red
                                .overlay(Text("\(valueX)"))
                                .frame(width: proxy.size.width * 0.8, height: proxy.size.height)
                                .offset(x: valueX)
                                .gesture(dragGesture)
                        }.onAppear {
                            withAnimation(offsetAnimation) {
                                valueX = 0
                            }
                        }
                    } // if
                } // end of Z
            } // geo
        }
    }
}

struct ViewWithDragGesture_Previews: PreviewProvider {
    static var previews: some View {
        AreaWithGesture()
    }
}

//
//  ContentView.swift
//  MetalKitMediumArticle
//
//  Created by Aniket Bane on 10/08/25.
//

import SwiftUI
import MetalKit

struct ContentView: View {
    @State private var start = Date()
    @State private var currentMode = 0 // 0 = Wave VE, 1 = Wave Metal, 2 = Kaleidoscope
    
    var descriptionText: String {
        switch currentMode {
        case 0:
            return "Wave (VisualEffect): Uses SwiftUI’s colorEffect shader for easy integration and good performance."
        case 1:
            return "Wave (MetalView): Uses the traditional Metal shader pipeline for full GPU control and custom rendering."
        case 2:
            return "Kaleidoscope: A colorful VisualEffect shader that creates a kaleidoscope pattern using SwiftUI shaders."
        default:
            return ""
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .ignoresSafeArea()
            
            // Main content switch
            switch currentMode {
            case 0:
                TimelineView(.animation) { timeline in
                    let time = start.distance(to: timeline.date)
                    Rectangle()
                        .ignoresSafeArea()
                        .visualEffect { content, proxy in
                            content.colorEffect(
                                ShaderLibrary.sinebow(.float2(proxy.size), .float(time))
                            )
                        }
                }
            case 1:
                MetalViewRepresentable()
                    .ignoresSafeArea()
            case 2:
                TimelineView(.animation) { timeline in
                    let time = start.distance(to: timeline.date)
                    Rectangle()
                        .ignoresSafeArea()
                        .visualEffect { content, proxy in
                            content.colorEffect(
                                ShaderLibrary.kaleidoscopeSinebow(.float2(proxy.size), .float(time))
                            )
                        }
                }
            default:
                EmptyView()
            }
            
            VStack(spacing: 8) {
                // Description label above picker
                Text(descriptionText)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Picker at bottom
                Picker("Select Mode", selection: $currentMode) {
                    Text("Wave (VisualEffect)").tag(0)
                    Text("Wave (MetalView)").tag(1)
                    Text("Kaleidoscope").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
            
            // Button pinned top-left
            VStack {
                HStack {
                    Button(action: {
                        if let url = URL(string: "https://www.linkedin.com/in/aniket-bane") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Image("linkedin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 42)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 44)
            .padding(.leading, 16)
            .ignoresSafeArea(edges: .top)
        }
    }
}

#Preview {
    ContentView()
}

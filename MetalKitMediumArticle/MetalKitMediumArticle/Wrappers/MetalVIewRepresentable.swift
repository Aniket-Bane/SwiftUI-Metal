//
//  MetalVIewRepresentable.swift
//  MetalKitMediumArticle
//
//  Created by Aniket Bane on 10/08/25.
//

import SwiftUI
import MetalKit

struct MetalViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> Renderer {
        return Renderer(frame: CGRect.zero, device: MTLCreateSystemDefaultDevice())
    }
    func updateUIView(_ uiView: Renderer, context: Context) { }
}

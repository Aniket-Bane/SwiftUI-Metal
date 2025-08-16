//
//  Renderer.swift
//  MetalKitMediumArticle
//
//  Created by Aniket Bane on 10/08/25.
//

import MetalKit
import simd

class Renderer: MTKView {

    private var commandQueue: MTLCommandQueue!
    private var pipelineState: MTLRenderPipelineState!
    private var vertexBuffer: MTLBuffer!
    private var startTime: CFTimeInterval = CACurrentMediaTime()

    // MARK: - Initializers

    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        commonInit()
    }

    required override init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Setup

    private func commonInit() {
        // Ensure device is set
        device = device ?? MTLCreateSystemDefaultDevice()
        commandQueue = device!.makeCommandQueue()

        // Quad covering entire viewport
        let vertexData: [float2] = [
            float2(-1, -1),
            float2( 1, -1),
            float2(-1,  1),
            float2( 1,  1)
        ]
        vertexBuffer = device!.makeBuffer(bytes: vertexData,
                                          length: MemoryLayout<float2>.stride * vertexData.count,
                                          options: [])

        // Load Metal shader functions
        let library = device!.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: "vertex_main")!
        let fragmentFunction = library.makeFunction(name: "sinebow_fragment")!

        // Setup pipeline
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = colorPixelFormat

        pipelineState = try! device!.makeRenderPipelineState(descriptor: pipelineDescriptor)

        // Configure MTKView
        isPaused = false
        enableSetNeedsDisplay = false
        framebufferOnly = false
        delegate = self

        startTime = CACurrentMediaTime()
    }
}

// MARK: - MTKViewDelegate

extension Renderer: MTKViewDelegate {
    func draw(in view: MTKView) {
        guard let drawable = currentDrawable,
              let descriptor = currentRenderPassDescriptor else { return }

        // Calculate elapsed time
        var currentTime = Float(CACurrentMediaTime() - startTime)

        // Create command buffer and encoder
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!

        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setFragmentBytes(&currentTime, length: MemoryLayout<Float>.stride, index: 0)

        // Draw quad as triangle strip
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)

        encoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Handle size change if needed
    }
}

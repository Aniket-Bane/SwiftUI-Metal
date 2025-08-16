//
//  Shaders.metal
//  MetalKitMediumArticle
//
//  Created by Aniket Bane on 10/08/25.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

vertex VertexOut vertex_main(const device float2* vertexArray [[buffer(0)]], uint vertexId [[vertex_id]]) {
    VertexOut out;
    out.position = float4(vertexArray[vertexId], 0, 1);
    out.uv = vertexArray[vertexId] * 0.5 + 0.5;
    return out;
}

fragment half4 sinebow_fragment(VertexOut in [[stage_in]], constant float &time [[buffer(0)]]) {
    float2 uv = in.uv * 2.0 - 1.0;
    uv.y -= 0.5;

    float wave = sin(uv.x + time);
    wave *= wave * 20;

    half3 waveColor = half3(0);

    for (float i = 0; i < 10; i++) {
        float luma = abs(1 / (100 * uv.y + wave));
        float y = sin(uv.x * sin(time) + i * 0.2 + time);
        uv.y += 0.02 * y;
        half3 rainBow = half3(
            sin(i * 0.3 + time) * 0.5 + 0.5,
            sin(i * 0.3 + 2 + sin(time * 0.3) * 2) * 0.5 + 0.5,
            sin(i * 0.3 + 4) * 0.5 + 0.5);
        waveColor += rainBow * luma;
    }

    return half4(waveColor, 1.0);
}

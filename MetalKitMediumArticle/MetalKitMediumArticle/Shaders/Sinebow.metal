//
//  Sinebow.metal
//  MetalKitMediumArticle
//
//  Created by Aniket Bane on 10/08/25.
//
#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] half4 sinebow(float2 pos, half4 color, float2 s, float t) {
    float2 uv = (pos / s.x) * 2 - 1;
    uv.y -= 0.25;

    float wave = sin(uv.x + t);
    wave *= wave * 50;

    half3 waveColor = half3(0);

    for (float i = 0; i < 10; i++) {
        float luma = abs(1 / (100 * uv.y + wave));
        float y = sin(uv.x * sin(t) + i * 0.2 + t);
        uv.y += 0.05 * y;
        half3 rainBow = half3(
            sin(i * 0.3 + t) * 0.5 + 0.5,
            sin(i * 0.3 + 2 + sin(t * 0.3) * 2) * 0.5 + 0.5,
            sin(i * 0.3 + 4) * 0.5 + 0.5 );
        waveColor += rainBow * luma;
    }

    return half4(waveColor, 1);
}


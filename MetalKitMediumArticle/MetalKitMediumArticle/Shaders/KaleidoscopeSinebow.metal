//
//  edgeGlow.metal
//  MetalKitMediumArticle
//
//  Created by Aniket Bane on 10/08/25.


#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 kaleidoscopeSinebow(float2 pos, half4 color, float2 s, float t) {
    // Normalize UV coordinates
    float2 uv = (pos / s.x) * 2.0 - 1.0;

    // Convert to polar coordinates
    float r = length(uv);
    float theta = atan2(uv.y, uv.x);

    // Apply 12-fold symmetry (hexagonal)
    float symmetry = 12.0;
    theta = abs(fmod(theta, 2.0 * 3.141592 / symmetry) - 3.141592 / symmetry);

    // Convert back to Cartesian coordinates
    uv = float2(cos(theta), sin(theta)) * r;


    // Sine wave distortion
    float wave = sin(uv.x + t);
    wave *= wave * 50.0;

    half3 waveColor = half3(0);

    // Rainbow wave loop
    for (float i = 0.0; i < 10.0; i++) {
        float luma = abs(1.0 / (100.0 * uv.y + wave));
        float y = sin(uv.x * sin(t) + i * 0.2 + t);
        uv.y += 0.05 * y;

        half3 rainBow = half3(
            sin(i * 0.3 + t) * 0.5 + 0.5,
            sin(i * 0.3 + 2.0 + sin(t * 0.3) * 2.0) * 0.5 + 0.5,
            sin(i * 0.3 + 4.0) * 0.5 + 0.5
        );

        waveColor += rainBow * luma;
    }

    return half4(waveColor, 1.0);
}



// Pip-Boy 3000 CRT shader for Ghostty
// Phosphor bloom + scanlines + vignette + subtle refresh flicker.

vec3 sampleGlow(vec2 uv, float radius) {
    vec3 c = vec3(0.0);
    float total = 0.0;
    for (float x = -2.0; x <= 2.0; x += 1.0) {
        for (float y = -2.0; y <= 2.0; y += 1.0) {
            vec2 off = vec2(x, y) * radius / iResolution.xy;
            float w = exp(-(x * x + y * y) * 0.5);
            c += texture(iChannel0, uv + off).rgb * w;
            total += w;
        }
    }
    return c / total;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Base sample + soft phosphor bloom so bright pixels bleed into neighbors.
    vec3 base = texture(iChannel0, uv).rgb;
    vec3 glow = sampleGlow(uv, 2.5);
    vec3 color = base + glow * 0.40;

    // Horizontal scanlines — soft, locked to physical pixels.
    float scan = 0.5 + 0.5 * sin(fragCoord.y * 3.14159);
    color *= mix(0.82, 1.0, scan);

    // Faint vertical aperture-grille hint.
    float mask = 0.92 + 0.08 * sin(fragCoord.x * 3.14159);
    color *= mask;

    // Vignette — dim the corners like a curved tube.
    vec2 vUV = uv * (1.0 - uv.yx);
    float vig = pow(vUV.x * vUV.y * 18.0, 0.30);
    color *= clamp(vig, 0.30, 1.0);

    // Subtle 60-cycle refresh flicker.
    color *= 0.97 + 0.03 * sin(iTime * 9.7);

    // Force the whole frame toward phosphor green in case any non-green leaks.
    color.r *= 0.85;
    color.b *= 0.78;

    fragColor = vec4(color, 1.0);
}

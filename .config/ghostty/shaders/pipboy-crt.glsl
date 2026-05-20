// ctOS digital shader for Ghostty
// Cold blue scanlines + data-stream flicker + vignette. No warm phosphor bloom.

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Base sample — no bloom, ctOS is clean and cold.
    vec3 color = texture(iChannel0, uv).rgb;

    // Horizontal scanlines — thin, hard-edged, digital.
    float scan = 0.5 + 0.5 * sin(fragCoord.y * 3.14159 * 1.5);
    color *= mix(0.88, 1.0, scan);

    // Subtle data-stream flicker: occasional horizontal bands scroll down.
    float band = mod(fragCoord.y - iTime * 60.0, iResolution.y);
    float flicker = smoothstep(4.0, 0.0, abs(band - iResolution.y * 0.5));
    color += vec3(0.0, 0.04, 0.06) * flicker;

    // Vignette — same shape, but push toward blue-black instead of green-black.
    vec2 vUV = uv * (1.0 - uv.yx);
    float vig = pow(vUV.x * vUV.y * 18.0, 0.30);
    color *= clamp(vig, 0.25, 1.0);

    // Cold-bias: suppress red/green warmth, let blue-cyan dominate.
    color.r *= 0.80;
    color.g *= 0.92;
    color.b = min(color.b * 1.08, 1.0);

    // Subtle refresh flicker at a higher frequency than Pip-Boy — feels digital.
    color *= 0.98 + 0.02 * sin(iTime * 24.0);

    fragColor = vec4(color, 1.0);
}

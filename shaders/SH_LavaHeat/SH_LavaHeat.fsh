varying vec2 v_vTexcoord;
varying vec4 v_vColour;


uniform float u_time;       // seconds
uniform float u_intensity;  // 0..1 from GML

const float WARP1 = 0.0005; 
const float WARP2 = 0.00075 / 2.0;  

void main() {
    // Wavy horizontal heat distortion (stronger with intensity)
    float w1 = sin(v_vTexcoord.y * 60.0 + u_time * 4.0) * WARP1;
    float w2 = sin(v_vTexcoord.y * 120.0 - u_time * 7.0) * WARP2;
    float warp = (w1 + w2) * u_intensity;

    vec2 uv = v_vTexcoord + vec2(warp, 0.0);
    uv = clamp(uv, 0.0, 1.0);

    // Subtle chromatic aberration that scales with intensity
    float fringe = 0.0005 * u_intensity;
    float r = texture2D(gm_BaseTexture, clamp(uv + vec2( fringe, 0.0), 0.0, 1.0)).r;
    float g = texture2D(gm_BaseTexture, uv).g;
    float b = texture2D(gm_BaseTexture, clamp(uv + vec2(-fringe, 0.0), 0.0, 1.0)).b;
    vec3 col = vec3(r, g, b);

    // Lava "glow" from the bottom of the screen
    float bottomGlow = smoothstep(0.4, 1.0, v_vTexcoord.y) * u_intensity;
    col += vec3(0.24, 0.04, 0.00) * bottomGlow;

    // Gentle vignette, fades in with intensity
    float d = distance(v_vTexcoord, vec2(0.5, 0.5));
    float vig = 1.0 - smoothstep(0.25, 0.9, d);
    col *= mix(1.0, vig, 0.5 * u_intensity);

    gl_FragColor = vec4(col, 1.0) * v_vColour;
}

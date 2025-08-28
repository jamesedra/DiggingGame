varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;       // seconds
uniform float u_speed;      // cycles per second (how fast it wipes)
uniform float u_width;      // band half-width in UV (0.0..0.5). e.g., 0.04
uniform float u_intensity;  // 0..1 (how strong the white mix)
uniform vec2  u_dir;        // direction of the wipe in UV space (normalize it)

// Optional color mask to limit glisten to gem (tweak or disable)
uniform vec3  u_maskColor;      // e.g., vec3(1.0, 0.18, 0.18) ~ red
uniform float u_maskTolerance;  // e.g., 0.55 (bigger = looser mask)

void main() {
    vec4 base = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;

    // Project UV onto the wipe direction (0..1)
    vec2 dir = normalize(u_dir);
    float pos = dot(v_vTexcoord, dir);

    // Phase moves from 0..1, wrapping
    float phase = fract(u_time * u_speed);

    // Distance to the moving band with wrap-around handling
    float d = min(abs(pos - phase), min(abs(pos - (phase - 1.0)), abs(pos - (phase + 1.0))));

    // Soft band via smoothstep (inner/outer edge)
    float edge_in  = u_width * 0.5;
    float edge_out = u_width;
    float band = 1.0 - smoothstep(edge_in, edge_out, d); // 0 outside, ~1 in center

    // Optional color mask so only the gem sparkles
    float mask = 1.0;
    if (u_maskTolerance >= 0.0) {
        float dist = distance(base.rgb, u_maskColor);
        mask = 1.0 - smoothstep(u_maskTolerance*0.75, u_maskTolerance, dist);
    }

    float amt = band * u_intensity * base.a * mask;     // respect transparency

    // Mix toward white for a glint
    vec3 out_rgb = mix(base.rgb, vec3(1.0), clamp(amt, 0.0, 1.0));
    gl_FragColor = vec4(out_rgb, base.a);
}

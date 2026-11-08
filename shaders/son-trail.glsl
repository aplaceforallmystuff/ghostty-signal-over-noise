// Signal Over Noise: trail. Style guide rules: one accent, flat, no glow, motion follows the reader.
// When the cursor moves more than a couple of cells, a flat tapered streak in the accent runs from
// where it was to where it landed and retracts into it (~0.25 s). #EF6351 on dark grounds,
// #B8412F on light. Mostly on background pixels; text under it gets only a light tint.

const float DUR       = 0.25;  // seconds the trail lives
const float STRENGTH  = 0.6;   // opacity of the streak
const float MIN_CELLS = 2.0;   // ignore single-step typing moves
const float TEXT_TINT = 0.3;   // how much shows over text

float bgMask(vec3 c) { return 1.0 - smoothstep(0.03, 0.15, distance(c, iBackgroundColor)); }
vec2 centre(vec4 c) { return c.xy + vec2(c.z * 0.5, -c.w * 0.5); }

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv  = fragCoord / iResolution.xy;
    vec4 col = texture(iChannel0, uv);

    float t = iTime - iTimeCursorChange;
    if (t < DUR && iCursorVisible.x > 0.5) {
        vec2  a    = centre(iPreviousCursor);
        vec2  b    = centre(iCurrentCursor);
        vec2  ab   = b - a;
        float len  = length(ab);
        float cell = max(iCurrentCursor.z, 1.0);
        if (len > cell * MIN_CELLS) {
            bool  dark   = dot(iBackgroundColor, vec3(0.2126, 0.7152, 0.0722)) < 0.5;
            vec3  accent = dark ? vec3(0.937, 0.388, 0.318) : vec3(0.722, 0.255, 0.184);
            float k    = t / DUR;
            float tail = 1.0 - (1.0 - k) * (1.0 - k) * (1.0 - k);   // tail retracts toward the cursor
            float h    = clamp(dot(fragCoord - a, ab) / dot(ab, ab), 0.0, 1.0);
            if (h >= tail) {
                float along = (h - tail) / max(1.0 - tail, 1e-3);
                float halfW = mix(0.15, 0.5, along) * iCurrentCursor.w;
                float d     = distance(fragCoord, a + ab * h);
                float body  = 1.0 - smoothstep(halfW - 0.75, halfW + 0.75, d);
                float alpha = STRENGTH * body * (1.0 - k * k);
                alpha *= mix(TEXT_TINT, 1.0, bgMask(col.rgb));
                col.rgb = mix(col.rgb, accent, alpha);
            }
        }
    }
    fragColor = col;
}

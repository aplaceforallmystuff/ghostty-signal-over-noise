// Signal Over Noise: break. The section break from signalovernoise.at, drawn once when a window gains focus.
// When a window gains focus, the site's section break transmits once across the top edge:
// static flickers up from the centre outwards, then the one red pulse draws left to right,
// then it clears. About one second, no idle loop. Background pixels only.
// Geometry matches the site's break: 2-unit bars on a 5-unit pitch, 18 units tall, 33-unit clear gap.

const float S        = 1.5;    // px per site unit (the site break is 18px tall; this is 27px)
const float MARGIN   = 16.0;   // px from the window edges
const float STATIC_T = 0.30;   // s for the static to spread from centre to the edges
const float DRAW_A   = 0.28;   // s: pulse starts drawing
const float DRAW_B   = 0.68;   // s: pulse fully drawn
const float FADE_A   = 0.80;   // s: everything starts to clear
const float FADE_B   = 1.05;   // s: gone

const vec2 TILE[8] = vec2[8](vec2(8.,2.), vec2(6.,6.), vec2(7.5,3.), vec2(5.,8.),
                             vec2(8.,2.), vec2(6.5,5.), vec2(7.5,3.), vec2(5.5,7.));
const vec2 P[8] = vec2[8](vec2(0.,9.), vec2(8.,9.), vec2(12.,2.), vec2(18.,16.),
                          vec2(24.,2.), vec2(30.,16.), vec2(34.,9.), vec2(42.,9.));

float bgMask(vec3 c) { return 1.0 - smoothstep(0.03, 0.15, distance(c, iBackgroundColor)); }
float segDist(vec2 p, vec2 a, vec2 b) {
    vec2 ab = b - a; float h = clamp(dot(p - a, ab) / dot(ab, ab), 0.0, 1.0);
    return length(p - a - ab * h);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv  = fragCoord / iResolution.xy;
    vec4 col = texture(iChannel0, uv);
    float t  = iTime - iTimeFocus;
    if (iFocus == 0 || t > FADE_B) { fragColor = col; return; }

    bool  dark   = dot(iBackgroundColor, vec3(0.2126, 0.7152, 0.0722)) < 0.5;
    vec3  signal = dark ? vec3(0.937, 0.388, 0.318) : vec3(0.722, 0.255, 0.184);   // #EF6351 / #B8412F
    vec3  noise  = dark ? mix(iBackgroundColor, iForegroundColor, 0.28) : vec3(0.604, 0.584, 0.545); // #9A958B
    float fade   = 1.0 - smoothstep(FADE_A, FADE_B, t);

    // Site units: x across from the left margin, y down from the top of the strip
    vec2  l   = vec2(fragCoord.x - MARGIN, (iResolution.y - MARGIN) - fragCoord.y) / S;
    float w   = (iResolution.x - 2.0 * MARGIN) / S;
    float mid = w * 0.5;
    if (l.x < 0.0 || l.x > w || l.y < -2.0 || l.y > 20.0) { fragColor = col; return; }

    float a = 0.0; vec3 tint = noise;

    // Static
    float x0 = floor(l.x / 5.0) * 5.0;
    if (l.x - x0 < 2.0 && abs(x0 + 1.0 - mid) >= 33.0) {
        vec2 tile = TILE[int(mod(x0 / 5.0, 8.0))];
        if (l.y >= tile.x && l.y <= tile.x + tile.y) {
            float arrive = STATIC_T * abs(x0 + 1.0 - mid) / mid;
            float on = smoothstep(arrive, arrive + 0.05, t);
            float flicker = (t - arrive < 0.12) ? step(0.5, fract(sin(x0 * 12.9898 + floor(t * 30.0)) * 43758.5453)) : 1.0;
            a = on * mix(0.35, 1.0, flicker);
        }
    }

    // Pulse, centred in the gap the bars actually leave
    float leftEnd  = floor((mid - 34.0) / 5.0) * 5.0 + 2.0;
    float rightBeg = ceil((mid + 32.0) / 5.0) * 5.0;
    float px0      = (leftEnd + rightBeg) * 0.5 - 21.0;
    float drawn    = 42.0 * smoothstep(DRAW_A, DRAW_B, t);
    if (l.x - px0 <= drawn) {
        vec2 p = l - vec2(px0, 0.0);
        float d = 1e9;
        for (int i = 0; i < 7; i++) d = min(d, segDist(p, P[i], P[i + 1]));
        float stroke = 1.0 - smoothstep(1.0 - 0.6 / S, 1.0 + 0.6 / S, d);   // 2 units wide, anti-aliased
        if (stroke > 0.0 && t >= DRAW_A) { a = max(a, stroke); tint = mix(tint, signal, stroke); }
    }

    col.rgb = mix(col.rgb, tint, a * fade * bgMask(col.rgb));
    fragColor = col;
}

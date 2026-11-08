// Signal Over Noise: ink. Like the site's section rules: draws left to right once, led by an orange nib.
// When the cursor jumps a long way (switching splits or panes, a big move), a 2px ink rule draws once under
// the cursor's row, left to right, led by a short accent nib that ends at the cursor, then clears.
// About 0.6 s. Background pixels only.

const float JUMP_CELLS = 8.0;   // only for moves at least this many cells long
const float RUN_CELLS  = 24.0;  // length of the rule, ending at the cursor
const float NIB_CELLS  = 1.5;   // length of the accent nib
const float DRAW       = 0.32;  // s to draw
const float END        = 0.60;  // s gone
const float INK_ALPHA  = 0.55;

float bgMask(vec3 c) { return 1.0 - smoothstep(0.03, 0.15, distance(c, iBackgroundColor)); }
vec2 centre(vec4 c) { return c.xy + vec2(c.z * 0.5, -c.w * 0.5); }

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv  = fragCoord / iResolution.xy;
    vec4 col = texture(iChannel0, uv);

    float t = iTime - iTimeCursorChange;
    if (t < END && iCursorVisible.x > 0.5) {
        float cell = max(iCurrentCursor.z, 1.0);
        float jump = distance(centre(iCurrentCursor), centre(iPreviousCursor));
        if (jump >= cell * JUMP_CELLS) {
            bool  dark   = dot(iBackgroundColor, vec3(0.2126, 0.7152, 0.0722)) < 0.5;
            vec3  accent = dark ? vec3(0.937, 0.388, 0.318) : vec3(0.722, 0.255, 0.184);
            float x1   = iCurrentCursor.x + cell;                       // rule ends just past the cursor
            float x0   = max(0.0, x1 - RUN_CELLS * cell);
            float y    = iCurrentCursor.y - iCurrentCursor.w - 1.0;     // just under the cursor's row
            float head = mix(x0, x1, 1.0 - pow(1.0 - clamp(t / DRAW, 0.0, 1.0), 3.0));
            float fade = 1.0 - smoothstep(DRAW, END, t);
            if (abs(fragCoord.y - y) <= 1.0 && fragCoord.x >= x0 && fragCoord.x <= head) {
                bool nib = fragCoord.x > head - NIB_CELLS * cell;
                vec3 c   = nib ? accent : iForegroundColor;
                float a  = (nib ? 1.0 : INK_ALPHA) * fade * bgMask(col.rgb);
                col.rgb = mix(col.rgb, c, a);
            }
        }
    }
    fragColor = col;
}

// -- CONFIGURATION --
vec4 TRAIL_COLOR = iCurrentCursorColor;
const float DURATION = 0.10;              // animation length in seconds
const float MAX_TRAIL_LENGTH = 0.15;      // max trail extent (normalized units)
const float THRESHOLD_MIN_DISTANCE = 1.5; // min movement to show trail (in cursor widths)
const float BLUR = 3.0;                   // edge softness in pixels
const float TAIL_TAPER = 0.05;            // tail width as fraction of head width (0=point, 1=no taper)
const float FADE_POWER = 1.5;             // opacity falloff curve (1=linear, higher=faster fade)

// --- EASING ---

float ease(float x) {
    return sqrt(1.0 - pow(x - 1.0, 2.0));
}

// --- SDF ---

float getSdfRectangle(in vec2 p, in vec2 center, in vec2 halfSize) {
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// --- HELPERS ---

vec2 norm(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

vec2 getRectCenter(vec4 rect) {
    return vec2(rect.x + rect.z * 0.5, rect.y - rect.w * 0.5);
}

// --- MAIN ---

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);

    vec2 uv = norm(fragCoord, 1.0);
    vec2 offsetFactor = vec2(-0.5, 0.5);

    vec4 cur = vec4(norm(iCurrentCursor.xy, 1.0), norm(iCurrentCursor.zw, 0.0));
    vec4 prev = vec4(norm(iPreviousCursor.xy, 1.0), norm(iPreviousCursor.zw, 0.0));

    vec2 centerCur = cur.xy - (cur.zw * offsetFactor);
    vec2 centerPrev = prev.xy - (prev.zw * offsetFactor);

    float lineLength = length(centerPrev - centerCur);
    float minDist = max(cur.z, cur.w) * THRESHOLD_MIN_DISTANCE;

    float sdfCursor = getSdfRectangle(uv, centerCur, cur.zw * 0.5);

    vec4 newColor = fragColor;
    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);

    if (lineLength > minDist) {
        // Animate head and tail positions along the path
        float tailDelay = MAX_TRAIL_LENGTH / lineLength;
        float isLong = step(MAX_TRAIL_LENGTH, lineLength);

        float headEased = mix(1.0, ease(progress), isLong);
        float tailEased = mix(ease(progress), ease(smoothstep(tailDelay, 1.0, progress)), isLong);

        vec2 headPos = mix(centerPrev, centerCur, headEased);
        vec2 tailPos = mix(centerPrev, centerCur, tailEased);

        vec2 trail = headPos - tailPos;
        float trailLen = length(trail);

        if (trailLen > 0.001) {
            vec2 dir = trail / trailLen;
            vec2 perp = vec2(-dir.y, dir.x);

            // Project fragment onto the trail line segment
            vec2 w = uv - tailPos;
            float proj = clamp(dot(w, dir), 0.0, trailLen);
            float t = proj / trailLen; // 0 = tail, 1 = head

            // Perpendicular distance from trail center line
            vec2 closest = tailPos + dir * proj;
            float perpDist = length(uv - closest);

            // Trail width matches cursor extent in the perpendicular direction
            float perpExtent = abs(perp.x) * cur.z + abs(perp.y) * cur.w;
            // Tapered half-width: full at head, narrow at tail
            float headHalf = perpExtent * 0.5;
            float tailHalf = perpExtent * TAIL_TAPER;
            float halfWidth = mix(tailHalf, headHalf, t);

            // Signed distance from tapered edge
            float dist = perpDist - halfWidth;

            // Smooth edge (consistent blur, no vertex artifacts)
            float blurSize = norm(vec2(BLUR), 0.0).x;
            float mask = 1.0 - smoothstep(-blurSize, blurSize, dist);

            // Opacity fades toward the tail
            float opacity = pow(t, FADE_POWER);

            float trailAlpha = mask * opacity;
            newColor = mix(newColor, TRAIL_COLOR, trailAlpha);

            // Current cursor renders on top of trail
            newColor = mix(newColor, fragColor, step(sdfCursor, 0.0));
        }
    }

    fragColor = newColor;
}

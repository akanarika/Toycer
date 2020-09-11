#define MAX_STEPS 100
#define MAX_DIST 200.
#define EPS 0.001

float getDist(in vec3 p) {
    vec3 c = vec3(0, 1, -4);
    vec3 s = vec3(3, .2, .2);
    float d =length(max(abs(p - c) - s, 0.));
    
    c = vec3(0, -1, -4);
    s = vec3(3, .2, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(-1.4, 1.7, -4);
    s = vec3(1, .2, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(1.4, 1.7, -4);
    s = vec3(1, .2, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(-1.4, .3, -4);
    s = vec3(1, .2, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(1.4, -.3, -4);
    s = vec3(1, .2, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(-1.4, -.3, -4);
    s = vec3(1, .2, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(1.4, .3, -4);
    s = vec3(1, .2, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(-1.4, -1.7, -4);
    s = vec3(1, .2, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(1.4, -1.7, -4);
    s = vec3(1, .2, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(-1.4, -2.3, -4);
    s = vec3(1, .2, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(1.4, -2.3, -4);
    s = vec3(1, .2, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(-2.2, -2, -4);
    s = vec3(.2, .3, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(-.6, -2, -4);
    s = vec3(.2, .3, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(2.2, -2, -4);
    s = vec3(.2, .3, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(.6, -2, -4);
    s = vec3(.2, .3, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(-2.2, 0, -4);
    s = vec3(.2, .3, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(-.6, 0, -4);
    s = vec3(.2, .3, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(2.2, 0, -4);
    s = vec3(.2, .3, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(.6, 0, -4);
    s = vec3(.2, .3, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(-1.4, 1.6, -4);
    s = vec3(.2, .6, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(1.4, 1.6, -4);
    s = vec3(.2, .6, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(-1.4, -1, -4);
    s = vec3(.2, .6, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    c = vec3(1.4, -1, -4);
    s = vec3(.2, .6, .2);
    d = min(d, length(max(abs(p - c) - s, 0.)));
    
    d = min(d, p.y + 4.);
    
    return d;
}

float rayMarch(in vec3 ro, in vec3 rd) {
    float t = 0.;
    for (int i = 0; i < MAX_STEPS; i++) {
        vec3 p = ro + t * rd;
        float tt = getDist(p);
        t += tt;
        if (tt < EPS || t > MAX_DIST) break;
    }
    return t;
}

vec3 getNormal(in vec3 p) {
	float d = getDist(p);
    vec2 e = vec2(EPS, 0);
    vec3 n = d - vec3(
        getDist(p - e.xyy),
        getDist(p - e.yxy),
        getDist(p - e.yyx));
    return normalize(n);
}

float getLight(in vec3 p) {
	vec3 light = vec3(0, 30, 50);
    light.xz += 5. * vec2(sin(iTime), cos(iTime));
    vec3 l = normalize(light - p);
    vec3 n = getNormal(p);
    float dif = clamp(0., 1., dot(l, n));
    if (rayMarch(p + EPS * 2. * n, l) < length(light - p)) return dif * .9;
    return dif ;
}

vec3 getBubble(in vec3 ro, in vec3 rd) {
    float d = MAX_DIST;
    float t = iTime;
    vec3 sp = vec3(0, -.5, 0);
    vec3 col = vec3(0);
    for (int i = 0; i < 20; i++) {
        d = min(d, max(0., length(sp.xy - rd.xy)));
        float size = .1;
        float c = smoothstep(size, size * (1. - .3), d);
        c *= mix(.7, 1., smoothstep(size * .8, size, d));
        col = max(col, c);
    }
    return col;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - iResolution.xy * .5) / iResolution.y;
    vec3 ro = vec3(0, 2.8, 2);
    vec3 rd = normalize(vec3(uv.x, uv.y - .5, -1));
    float d = rayMarch(ro, rd);
    fragColor = vec4(getLight(ro + d * rd) * d * .1, 0, 0, 1);
}
#define MAX_STEPS 200
#define EPS .001
#define MAX_DIST 200.

mat2 Rot(float a) {
	float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}

float dSphere(vec3 p, vec4 s) {
	return length(s.xyz - p) - s.w;
}

float dPlane(vec3 p, float y) {
    return p.y - sin(y);
}

float dCapsule(vec3 p, vec3 a, vec3 b, float r) {
    vec3 ab = b - a;
    vec3 ap = p - a;
    float t = dot(ap, ab) / dot(ab, ab);
    t = clamp(t, 0., 1.);
    vec3 h = a + t * (b - a);
    return length(p - h) - r;
}

float dCube(vec3 p, vec3 q, vec3 size) {
	return length(max(abs(p - q) - size, 0.));
}

float dTorus(vec3 p, vec4 q, float r) {
	vec3 pxz = vec3(p.x, q.y, p.z);
    return length(vec2(length(q.xyz - pxz) - q.w, p.y - q.y)) - r;
}

float dCylinder(vec3 p, vec3 a, vec3 b, float r) {
	vec3 ap = p - a;
    vec3 ab = b - a;
    float t = dot(ap, ab) / dot(ab, ab);
    //t = clamp(t, 0., 1.);
    vec3 c = a + t * (b - a);
    vec3 cp = p - c;
    float d = length(cp) - r;
    float y = (abs(t - 0.5) - 0.5) * length(ab);
    float e = length(max(vec2(d, y), 0.));
    float i = min(max(d, y), 0.);
    
    return e + i;
}

float getDist(vec3 p) {
    float d = dSphere(p, vec4(-10, 2, -9, 2));
	d = min(d, dPlane(p, 0.));
    d = min(d, dCapsule(p, vec3(-2, 1, -9), vec3(2, 1, -12), 1.));
    d = min(d, dCube(p, vec3(10, 2, -10), vec3(2, 1, 3)));
    d = min(d, dTorus(p, vec4(-5, .8, -3, 2), .8));
    d = min(d, dCylinder(p, vec3(2, 1, -4), vec3(5, 1, -1), 1.));
    return d;
}

float rayMarch(in vec3 ro, in vec3 rd) {
	float t = 0.;
    for (int i = 0; i < MAX_STEPS; i++) {
    	vec3 p = ro + rd * t;
        float tt = getDist(p);
        t += tt;
        if (tt < EPS || tt > MAX_DIST) break;
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
	vec3 light = vec3(0, 10, -4);
    light.xz += 5. * vec2(sin(iTime), cos(iTime));
    vec3 l = normalize(light - p);
    vec3 n = getNormal(p);
    float dif = clamp(dot(l, n), 0., 1.);
    if (rayMarch(p + EPS * 2. * n, l) < length(light - p)) return dif * .2;
    return dif;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (2. * fragCoord - iResolution.xy) / iResolution.y / 2.;

    vec3 ro = vec3(0, 8, 10);
    vec3 rd = normalize(vec3(uv.x, uv.y - .5, -1.));
    
    float t = rayMarch(ro, rd);
    
    vec4 col = vec4(getLight(ro + t * rd)) * vec4(.2, .6, .4, 1.);
    fragColor = sqrt(col);
}

vec2 getBall(vec3 p) {
    vec3 c = vec3(5, 0, 0);
    return vec2(length(p - c) - 1., 1.);
}

vec2 getBox(vec3 p) {
    vec3 size = vec3(1, 1, 2);
    vec3 c = vec3(-5, 0, 0);
    return vec2(length(max(abs(p - c) - size, 0.)), 2.);
}

vec2 getTorus(vec3 p) {
	vec3 c = vec3(0, 0, 5);
    float r1 = 1.5;
    float r2 = 1.;
    vec3 pxz = vec3(p.x, 0, p.z);
    vec3 pxzc = c - pxz;
    float lpxzc = length(pxzc);
    vec3 q = pxz + pxzc * (lpxzc - r1) / lpxzc;
    return vec2(length(q - p) - r2, 3.);
}

vec2 getCapsule(vec3 p) {
	vec3 a = vec3(1, 2, -2);
    vec3 b = vec3(-1, 0, -5);
    float r = 1.;
    vec3 ba = a - b;
    vec3 pa = a - p;
    float t = clamp(dot(pa, ba) / dot(ba, ba), 0., 1.);
    return vec2(length(pa - t * ba) - r, 4.);
}

vec2 getPlane(vec3 p) {
    return vec2(p.y + 1., 5.);
}

vec2 getDist(vec3 p) {
    float d = 1000000.;
    float id = -1.;
    vec2 res = getBall(p);
    if (res.x < d) {
        d = res.x;
        id = res.y;
    }
    res = getBox(p);
    if (res.x < d) {
        d = res.x;
        id = res.y;
    }
    res = getTorus(p);
    if (res.x < d) {
        d = res.x;
        id = res.y;
    }
    res = getCapsule(p);
    if (res.x < d) {
        d = res.x;
        id = res.y;
    }
    res = getPlane(p);
    if (res.x < d) {
        d = res.x;
        id = res.y;
    }
    return vec2(d, id);
}

vec3 getNorm(vec3 p) {
	float eps = 0.001;
    return normalize(vec3(getDist(vec3(p.x + eps, p.y, p.z)).x - getDist(vec3(p.x - eps, p.y, p.z)).x,
                          getDist(vec3(p.x, p.y + eps, p.z)).x - getDist(vec3(p.x, p.y - eps, p.z)).x,
                          getDist(vec3(p.x, p.y, p.z + eps)).x - getDist(vec3(p.x, p.y, p.z - eps)).x));
}

vec2 rayMarch(in vec3 ro, in vec3 rd) {
	float t = 0.;
    float id = -1.;
    for (int i = 0; i < 100; i++) {
    	vec3 p = ro + t * rd;
        float h = getDist(p).x;
        id = getDist(p).y;
        t += h;
        if (t > 300. || h < 0.001) break; 
    }
    if (t > 300.) {
        t = -1.;
        id = -1.;
    }
    return vec2(t, id);
}

mat2 rot(float a) {
    return mat2(cos(a), -sin(a), sin(a), cos(a));
}

mat3 v(vec3 ri, vec3 up, vec3 forw) {
    return transpose(mat3(ri, up, forw));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord - iResolution.xy * .5) / iResolution.y;

    vec3 ro = vec3(0, 10, 30);
    vec3 target = vec3(0, 0, 0);
    vec3 rd = normalize(vec3(uv.x , uv.y + .1, -1));
    
    if (iMouse.z > 0.) ro.xz *= rot(iMouse.x * 10. / iResolution.x);
    else ro.xz *= rot(iTime * .5);
    
    vec3 up = normalize(vec3(0, 1, 0));
    vec3 forw = normalize(ro - target);
    vec3 ri = normalize(cross(up, forw));
    rd *= v(ri, up, forw);

    vec2 rm = rayMarch(ro, rd);
    vec3 p = ro + rm.x * rd;
    
    vec3 col = rm.x > 0. ? vec3(getNorm(p)) : vec3(.4, .7, .8);
    if (rm.y > 4.5) {
    	col = vec3(.8, .8, .3);
    }

    // Output to screen
    fragColor = vec4(col, 1.0);
}
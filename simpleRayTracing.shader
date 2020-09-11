// ---- Util ----
const float Pi = 3.14159265359;
float remap01(float a, float b, float t) { return (t - a) / (b - a);}
float eps = 0.001; // epsilon
vec4 bg_color = vec4(.9, .8, .6, 1.);

// ---- Material ----
struct Material {
    vec3 dif;
    vec3 spec;
    bool ref;
};
    
Material makeMaterial(in vec3 d, in vec3 s, in bool r) { 
    Material m; m.dif = d; m.spec = s; m.ref = r;
    return m;
}

// ---- Ray ----
struct Ray {
    vec3 o;
    vec3 d;
    float tmin;
    float tmax;
};
    
struct Hit {
    bool did;
    bool inside;
    vec3 p;
    vec3 n;
    float t;
    Material m;
};
    
Ray makeRay(in vec3 o, in vec3 d) { 
    Ray r; r.o = o; r.d = d; r.tmin = 0.; r.tmax = 1000000000.; 
    return r;
}

// ---- Geometry ----
struct Plane {
    vec3 n;
    vec3 p;
    Material m;
};
    
Plane makePlane(in vec3 n, in vec3 p, in Material m) {
    Plane pl; pl.n = n; pl.p = p; pl.m = m;
    return pl;
}

struct Sphere {
    vec3 o;
    float r;
    Material m;
};

Sphere makeSphere(in vec3 o, in float r, in Material m) { 
    Sphere s; s.o = o; s.r = r; s.m = m; 
    return s;
}

bool intersectPlane(in Plane p, in Ray r, inout Hit hit) {
    float t = (dot(p.n, p.p) - dot(p.n, r.o)) / dot(p.n, r.d);
    if (dot(p.n, r.d) > 0.) return false;
    if (t > r.tmin && t < r.tmax) {
        hit.did = true;
        hit.t = t;
        hit.p = r.o + r.d * t;
        hit.n = normalize(p.n);
        hit.m = p.m;
        return true;
    }
    return false;
}
    
bool intersectSphere(in Sphere s, in Ray r, inout Hit hit) {
    float a = dot(r.d, r.d);
    float b = 2. * dot(r.o - s.o, r.d);
    float c = dot(r.o - s.o, r.o - s.o) - s.r * s.r;
    float delta = b * b - 4. * a * c;
    if (delta < 0.) return false;
    float t = (-b - sqrt(delta)) / (2. * a);
    if (t > r.tmin && t < r.tmax) {
        hit.did = true;
        hit.t = t;
        hit.p = r.o + r.d * t;
        hit.n = normalize(hit.p - s.o);
        hit.m = s.m;
        if (dot(hit.n, r.d) > 0.) {
            hit.inside = true;
            hit.n = -hit.n;
        }
        return true;
    }
    t = (-b + sqrt(delta)) / (2. * a);
    if (t > r.tmin && t < r.tmax) {
        hit.did = true;
        hit.t = t;
        hit.p = r.o + r.d * hit.t;
        hit.n = normalize(hit.p - s.o);
        hit.m = s.m;
        if (dot(hit.n, r.d) > 0.) {
            hit.inside = true;
            hit.n = -hit.n;
        }
        return true;
    }
    return false;
}

bool intersectScene(in Ray r, inout Hit hit) {
    bool didHit = false;
    
    Plane p = makePlane(vec3(0., 1., 0.), vec3(0., -1., 0.),
                        makeMaterial(vec3(.6, .5, .2), vec3(0.), false));
    if (intersectPlane(p, r, hit)) {
        r.tmax = hit.t;
        didHit = true;
    }
    
    for (int i = 0; i < 4; i++) {
        float ra = fract(sin(float(i + 2))) * .3 + 2.;
        float cr = fract(cos(float(i + 4))) * .5 + .4;
        float cg = fract(sin(float(i + 5))) * .5 + .2;
        float cb = fract(1. - cos(float(i + 6))) * .5 + .5;
        Sphere s = makeSphere(vec3(-sin(float(i * 2)) * 10. + 3., ra - 1.,  -25. -cos(float(i + 2) * 3.) * 10.), ra, 
                           makeMaterial(vec3(cr, cg, cb), vec3(.6), i == 3 ? true : false));
        s.o.x += ra * sin(ra * iTime * .4);
        s.o.z += 2. * ra * cos(ra * iTime * .4);
        if (intersectSphere(s, r, hit)) {
            r.tmax = hit.t;
            didHit = true;
        }
    }
                        
    return didHit;
}

vec4 color(in Ray r, inout Hit hit) {
    // Light direction
    vec3 light = normalize(vec3(5., 8., 5.));
    
    vec4 col;
    if (intersectScene(r, hit)) {
        vec3 l = light;
        float dif = max(0., dot(l, hit.n));
        vec3 h = normalize(l + r.d);
        float spc = pow(max(0., dot(h, hit.n)), 16.);
        
        // Shadow test ray
        Ray str = makeRay(hit.p + eps * l, l);
        Hit sth;
        col += 2. * vec4(hit.m.dif, 1.)  // diffuse color
                  * dif
             + 8. * vec4(hit.m.spec, 1.)  // spec color
                 * spc
             + .02 * vec4(hit.m.dif, 1.);  // ambient color**/
        return intersectScene(str, sth) ?  sqrt(col) * .2 : sqrt(col);
    }
    return col;
}


vec4 calcColor(in Ray r) {
    Ray nr = r;
    float fac = 1.;
    vec4 col = bg_color;
    for (int i = 0; i < 5; i++) {
        Hit hit;
        vec4 att = color(nr, hit);
        if (!hit.did) {
            return col;
        } else if (!hit.m.ref) {
            nr.d = normalize(reflect(nr.d, hit.n));
            nr.o = hit.p + eps * nr.d;
            col *= att;
            if (hit.m.spec == vec3(0.)) return col;
        } else {
            att = vec4(.9, .9, .9, 1.);
            float eoe = 1.3;
            if (!hit.inside) eoe = 1. / eoe;
            nr.d = normalize(refract(nr.d, hit.n, eoe));
            nr.o = hit.p + eps * nr.d;
            col *= att;
        }
    }
    return vec4(0.);
}

void shootRays(vec3 ro, vec3 rd, out vec4 col) {
    float unit_x = 1. / iResolution.x;
    float unit_y = 1. / iResolution.y;
    // 4 samples
    vec2 offset[4] = vec2[4](vec2(-unit_x / 2., -unit_y / 2.), vec2(-unit_x / 2., unit_y / 2.),
                             vec2(unit_x / 2., -unit_y / 2.), vec2(unit_x / 2., unit_y / 2.));
    vec4 total;
    for (int i = 0; i < 4; i++) {
        vec2 off = offset[i];
        Ray r = makeRay(ro - vec3(off, 0.), normalize(rd));
        total += calcColor(r);
    }
    col = total / 4.;
}

mat3 lookat(vec3 cam, vec3 target) {
    vec3 forward = normalize(target - cam);
    vec3 right = cross(normalize(vec3(0, 1, 0)), forward);
    vec3 up = cross(forward, right);
   
    return mat3(right, up, forward);
}

// ---- main ----
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized pixel coordinates (y from 0 to 1)
    vec2 uv = fragCoord / iResolution.xy;
    // y from -.5 to .5
    uv -= 0.5;
    // x from -.5 * ratio to .5 * ratio
    uv.x *= iResolution.x / iResolution.y;
    
    // Mouse
    vec2 m = iMouse.xy / iResolution.xy;
    
    // Ray
    vec3 ro = vec3(0., 0., 1.);
    vec3 tar = vec3(0., 0., 0.);
    mat3 view = lookat(ro, tar);
    
    vec3 rd = normalize(view * vec3(uv.x, uv.y, 1));
    
    // Output to screen
    vec4 col;
    shootRays(ro, rd, col);
    fragColor = col;
}

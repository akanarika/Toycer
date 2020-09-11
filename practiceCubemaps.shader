mat3 lookat(vec3 cam) {
    vec3 forward = normalize(-cam);
    vec3 right = cross(forward, normalize(vec3(0, 1, 0)));
    vec3 up = cross(right, forward);
   
    return mat3(right, up, forward);
}

mat2 rot(float a) {
    float c = cos(a);
    float s = sin(a);
    return mat2(c, -s, s, c);
}

bool hitSphere(in vec3 o, in vec3 d, in vec3 p, in float r, out vec3 hit, out vec3 n) {
    float a = dot(d, d);
    float b = 2. * dot(o - p, d);
    float c = dot(o - p, o - p) - r * r;
    float delta = b * b - 4. * a * c;
    if (delta < 0.) return false;
    float t = (-b - sqrt(delta)) / (2. * a);
    hit = o + d * t;
    n = normalize(hit - p);
    return true;
}

vec3 color(vec3 o, vec3 d) {
    vec3 light = normalize(vec3(-5, 50, -8));
    light.xz *= rot(iTime * .1 + iMouse.x * .1);
    vec3 p = vec3(0, 0, 0);
    float r = .8;
    vec3 hit, n;
    if (hitSphere(o, d, p, r, hit, n)) {
        vec3 ref = reflect(hit, d);
        return texture(iChannel0, -ref).xyz * .8
            + pow(max(0., dot(n, normalize(-d + light))), 64.);
    }
    
	return texture(iChannel0, d).xyz;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = 2. * (fragCoord.xy - .5 * iResolution.xy) / iResolution.y;
    
    vec3 cam = vec3(1, 0, 1);
    cam.xz *= rot(iTime * .1 + iMouse.x * .1);
    vec3 d = lookat(cam) * normalize(vec3(uv, -1));
    vec3 col = color(cam, d);

    fragColor = vec4(sqrt(col), 1);
}
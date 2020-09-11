#define TWOPI 6.28318530718

bool disk(in vec2 p, in vec2 center, in float r) {
    if (length(p - center) < r) {
        return true;
    }
    return false;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = 2. * (fragCoord.xy - .5 * iResolution.xy) / iResolution.y;

    vec3 col = .1 + .5 * vec3(abs(sin(iTime / 12.)), abs(cos(iTime / 12.)), abs(sin(iTime / 12.) + cos(iTime / 12.)) / 2.);

    float angle = 0.;
    for (int i = 1; i <= 12; i++) {
        float x = sin(angle);
        float y = cos(angle);
        vec2 p = vec2(x, y) * .8;
        float r = smoothstep(.2, 0., 1. + sin(float(i) / 2. + iTime / 2.)) * .05 + .1;
        if (disk(uv, p, r)) {
        	col = vec3(sin(iTime) + 1., cos(iTime) + 1., .2) * .6 + vec3(r * 4.);
        }
        angle += TWOPI / 12.;
    }
    
    // Output to screen
    fragColor = vec4(col,1.0);
}
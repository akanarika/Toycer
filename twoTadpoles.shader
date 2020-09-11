float calc(vec2 uv, float ratio) {
    float col = 1.0;
    float tail = smoothstep(-.1, .8, abs(.9 * sin(uv.x - .1)));
    if (uv.x < -.15 && uv.x > -ratio && abs(uv.y * 1.1) < .32) {
        col = smoothstep(0., .05 * (1. - tail) * (1. - sin(uv.x)), 2. * abs(uv.y + .2 * sin(iTime * 10.) * sin(uv.x) * sin(uv.x) * sin(uv.x)) * tail);
    } else {
        col = smoothstep(0.7, .8, 3.5 * length(vec2((uv.x - 0.11) * .8, uv.y)));
    }
    return col;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = 2. * (fragCoord.xy - .5 * iResolution.xy) / iResolution.y;
    
    float ratio = iResolution.x / iResolution.y;
    
    vec2 p = vec2(uv.x + step(uv.y, 0.) - .5, abs(uv.y) - .4 + (step(uv.y, 0.) - .2) * sin(iTime + step(uv.y, 0.)) * .2);

    float col = calc(p, ratio);
    
    fragColor = vec4(col);
}
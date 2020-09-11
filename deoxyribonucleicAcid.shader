#define pi 3.1415926535897932384626433832795

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = 3. * (fragCoord.xy - iResolution.xy * .5) / iResolution.y;

    vec3 c;
    for (int i = 0; i < 10; i++) {
        float h = -0.88 + .22 * float(i);
        float t = iTime * .9 + h;
        vec2 p1 = vec2(.2 * sin(t * 2.), h);
    	vec2 p2 = vec2(.2 * sin(t * 2. + pi), h);
    	c += vec3(.2, .4, .5) * smoothstep(.1 + .02 * cos(t * 2.),
                                           .08 + .02 * cos(t * 2.),
                                           length(uv - p1))
        + vec3(.6, .4, .5) * smoothstep(.1 - .02 * cos(t * 2.),
                                           .08 - .02 * cos(t * 2.),
                                           length(uv - p2));
        c += vec3(.1) * smoothstep(0.012, 0.01, length(uv - p1))
            + vec3(.1) * smoothstep(0.012, 0.01, length(uv - p2));
        if ((abs(uv.x - p1.x) < abs(p1.x - p2.x)) && (abs(uv.x - p2.x) < abs(p1.x - p2.x))) {
        	c += vec3(.1) * smoothstep(0.012, 0.01, abs(uv.y - h));
    	}
    }
    

    fragColor = vec4(c, 1.0);
}
vec2 N22(vec2 p) {
    vec3 a = fract(p.xyx * vec3(452.6, 725.34, 921.2));
    a += dot(a, a + 16.2);
    return fract(vec2(a.x * a.y, a.y * a.z));
}

mat2 rot(float a) {
    return mat2(cos(a), -sin(a), sin(a), cos(a));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = 2. * (fragCoord.xy - .5 * iResolution.xy) / iResolution.y;

    float m = 0.;
    float t = iTime + 100.;
    
    float minDist = 200.;
    
    vec3 waterCol = vec3(0.1, 0.5, 0.7);
    
    for (float i = 0.; i < 50.; i++) {
        vec2 n = N22(vec2(i));
        vec2 p = rot(iTime * sqrt(.1 * (length(uv + n))) * 0.0008) 
            * sin(n * t * .3) 
            * vec2(iResolution.x / iResolution.y, 1.);
        
        float d = length(uv - p) * .5;
        m += d * length(n);
        
        minDist = min(minDist, d);
    }
    

    vec3 col = vec3(pow(minDist, 1.8)) * waterCol * 6. + waterCol * (.8 + 0.05 * length(N22(uv + iTime)));

    fragColor = vec4(col,1.0);
}
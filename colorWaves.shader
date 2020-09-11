void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = 2. * (fragCoord.xy - .5 * iResolution.xy) /iResolution.y;

    vec3 col = vec3(0);
    vec3 TOKI = vec3(238, 169, 169) / 255.;
    vec3 NANOHANA = vec3(247, 217, 76) / 255.;
    vec3 SORA = vec3(88, 178, 220) / 255.;
    vec3 ROKUSYOH = vec3(36, 147, 110) / 255.;
    vec3 ENTAN = vec3(215, 84, 85) / 255.;
    vec3 USUKI = vec3(250, 214, 137) / 255.;
    vec3 BENIMIDORI = vec3(123, 144, 210) / 255.;
    vec3 AKE = vec3(203, 84, 58) / 255.;
    vec3 SHIRONEZUMI = vec3(189, 192, 186) / 255.;
    vec3 TONOCHA2 = vec3(79, 114, 108) / 225.;
    
    
    if (uv.y - .8 > .1 * sin(uv.x + iTime)) {
        col = TOKI;
    } else if (uv.y - .6 > .1 * cos(uv.x + iTime * .4)) {
        col = NANOHANA;
    } else if (uv.y - .4 > .1 * sin(uv.x + iTime * .6)) {
        col = SORA;
    } else if (uv.y - .2 > .1 * cos(uv.x + iTime * .9)) {
        col = ROKUSYOH;
    } else if (uv.y - 0. > .1 * sin(uv.x + iTime * .3)) {
        col = USUKI;
    } else if (uv.y + .2 > .1 * cos(uv.x + iTime * .5)) {
        col = ENTAN;
    } else if (uv.y + .4 > .1 * sin(uv.x + iTime * .7)) {
        col = BENIMIDORI;
    } else if (uv.y + .6 > .1 * cos(uv.x + iTime * .6)) {
        col = AKE;
    } else if (uv.y + .8 > .1 * sin(uv.x + iTime * .8)) {
        col = SHIRONEZUMI;
    } else {
        col = TONOCHA2;
    }
    
    if (uv.x - 1.6 > .1 * sin(uv.y + iTime)) {
        col *= clamp(vec3(.4, .2, .9), vec3(0), vec3(1));
    } else if (uv.x - 1.4 > .1 * cos(uv.y + iTime * .3)) {
        col += clamp(vec3(.1, .8, .3), vec3(0), vec3(1));
    }  else if (uv.x - 1.2 > .1 * sin(uv.y + iTime * .7)) {
        col -= clamp(vec3(.2, .7, .1), vec3(0), vec3(1));
    }  else if (uv.x - 1. > .1 * cos(uv.y + iTime * .4)) {
        col *= clamp(vec3(.2, .7, .1), vec3(0), vec3(1));
    }  else if (uv.x - .8 > .1 * sin(uv.y + iTime * .2)) {
        col *= clamp(vec3(.9, .2, .1), vec3(0), vec3(1));
    }  else if (uv.x - .6 > .1 * cos(uv.y + iTime * .6)) {
        col += clamp(vec3(.1, .1, .2), vec3(0), vec3(1));
    }  else if (uv.x - .4 > .1 * sin(uv.y + iTime * .4)) {
        col -= clamp(vec3(.1, .1, .2), vec3(0), vec3(1));
    }  else if (uv.x - .2 > .1 * cos(uv.y + iTime * .5)) {
        col *= clamp(vec3(.1, .1, .2), vec3(0), vec3(1));
    }  else if (uv.x - 0. > .1 * sin(uv.y + iTime * .9)) {
        col *= clamp(vec3(.8, .4, .9), vec3(0), vec3(1));
    }  else if (uv.x + .2 > .1 * cos(uv.y + iTime * .4)) {
        col = col;
    }  else if (uv.x + .4 > .1 * sin(uv.y + iTime * .6)) {
        col *= clamp(vec3(.2, .4, .9), vec3(0), vec3(1));
    }  else if (uv.x + .6 > .1 * cos(uv.y + iTime * .8)) {
        col -= clamp(vec3(.2, .4, .9), vec3(0), vec3(1));
    }  else if (uv.x + .8 > .1 * sin(uv.y + iTime * .8)) {
        col += clamp(vec3(.4, .1, .2), vec3(0), vec3(1));
    }  else if (uv.x + 1. > .1 * cos(uv.y + iTime * .3)) {
        col *= clamp(vec3(.4, .1, .2), vec3(0), vec3(1));
    }  else if (uv.x + 1.2 > .1 * sin(uv.y + iTime * .6)) {
        col -= clamp(vec3(.5, .1, .2), vec3(0), vec3(1));
    }  else if (uv.x + 1.4 > .1 * cos(uv.y + iTime * .2)) {
        col += clamp(vec3(.5, .1, .2), vec3(0), vec3(1));
    }  else if (uv.x + 1.6 > .1 * sin(uv.y + iTime * .7)) {
        col *= clamp(vec3(.5, .1, .2), vec3(0), vec3(1));
    }

    fragColor = vec4(col,1.0);
}
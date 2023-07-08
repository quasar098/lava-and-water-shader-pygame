#version 330 core

uniform sampler2D iChannel0;
uniform sampler2D in_tex;
uniform float iTime;
uniform float colorScheme;

in vec2 uvs;
out vec4 fragColor;

void main() {

    // configurables
    float speed = 1.0;
    float scale = 0.02;
    float timeSpeed = 0.00002;
    float layer2offset = 0.0006;

    vec2 uv = uvs;
    uv.x = uv.x * 16.0 / 9.0;

    uv.x = round(uv.x*100.0)/100.0;
    uv.y = round(uv.y*100.0)/100.0;
    uv = uv * scale;
    float fakeTime = iTime*timeSpeed+1.0;

    vec4 col = vec4(0.925, 0.41, 0.15, 1.0);
    if (colorScheme == 1) {
        col = vec4(0.173, 0.91, 0.965, 1.0);
    }

    // bright red
    vec4 water0 = texture(iChannel0, uv + fakeTime*speed*vec2(-0.02, -0.035)).xxxx;
    vec4 water1 = texture(iChannel0, uv + fakeTime*speed*2.0*vec2(0.039, 0.013)).xxxx;

    vec4 noise0 = vec4((water0*water1)*2.0);

    if (0.6 > noise0.x && noise0.x > 0.4) {
        if (colorScheme == 0) {
            col = vec4(0.839, 0.157, 0.267, 1.0);
        } else {
            col = vec4(0, 0.5, 0.7, 1.0);
        }
    }

    // dark maroon
    vec4 water2 = texture(iChannel0, uv + fakeTime*speed*vec2(0.012, -0.04)).xxxx;
    vec4 water3 = texture(iChannel0, uv + fakeTime*speed*2.0*vec2(-0.02, 0.021)).xxxx;

    vec4 noise1 = vec4((water2*water3)*1.8);

    if (0.52 > noise1.x && noise1.x > 0.43) {
        if (colorScheme == 0) {
            col = vec4(0.612, 0.102, 0.204, 1.0);
        } else {
            col = vec4(0, 0.345, 0.55, 1.0);
        }
    }

    // bright yellow
    vec4 water4 = texture(iChannel0, uv + fakeTime*speed*vec2(0.012, -0.04)-vec2(0, -layer2offset)).xxxx;
    vec4 water5 = texture(iChannel0, uv + fakeTime*speed*2.0*vec2(-0.02, 0.021)-vec2(0, -layer2offset)).xxxx;

    vec4 noise2 = vec4((water4*water5)*1.8);

    if (0.52 > noise2.x && noise2.x > 0.43) {
        if (colorScheme == 0) {
            col = vec4(0.961, 0.682, 0.22, 1.0);
        } else {
            col = vec4(0.99, 0.99, 0.99, 1.0);
        }
    }

    vec4 vexture = texture(in_tex, uvs);

    if (vexture.rgb != vec3(0, 0, 0)) {
        fragColor = vexture;
    } else {
        fragColor = col;
    }
}
// credit to bees: https://discord.com/channels/1095808506239651942/1406047711450501211/1494725876485456067

precision highp float;

varying vec2 f_src_pos;

uniform sampler2D u_texture;
uniform vec2 u_src_size;

const vec2 PIE_RADIUS = vec2(320/2-2, 160/2-1);
const vec2 PIE_CENTER = vec2(170, 320);

void main() {
    vec2 d = (u_src_size * (1.0 - f_src_pos) - PIE_CENTER) / PIE_RADIUS;
    if (d[0] * d[0] + d[1] * d[1] <= 1.0) {
        gl_FragColor = texture2D(u_texture, f_src_pos);
    } else {
        discard;
    }
}

// vim:ft=glsl

precision highp float;

#define rgb(r,g,b)   (vec4((r)/255.0, (g)/255.0, (b)/255.0, 1.0))
#define is(c)   (all(lessThan(abs(color.rgb - (c).rgb), vec3(0.01))))

const vec4 c_debug = rgb(228.0, 198.0, 70.0);
const vec4 c_blockentities = rgb(198.0, 198.0, 110.0);
const vec4 c_entities = rgb(228.0, 70.0, 196.0);
const vec4 c_unspecified = rgb(70.0, 206.0, 102.0);

const vec4 c_root = vec4(1.0);
const vec4 c_frame = rgb(198.0, 236.0, 108.0);
const vec4 c_extract = rgb(102.0, 204.0, 196.0);
const vec4 c_level = rgb(100.0, 206.0, 196.0);

const vec4 c_tick = rgb(102.0, 68.0, 204.0);
const vec4 c_piglin_brute = rgb(68.0, 110.0, 70.0);
const vec4 c_mob_spawner = rgb(78.0, 228.0, 204.0);
const vec4 c_vault = rgb(206.0, 78.0, 100.0);
const vec4 c_trial_spawner = rgb(100.0, 70.0, 102.0);
const vec4 c_bell = rgb(238.0, 102.0, 228.0);
const vec4 c_campfire = rgb(76.0, 70.0, 100.0);
const vec4 c_skull = rgb(100.0, 78.0, 68.0);
const vec4 c_sign = rgb(70.0, 110.0, 110.0);

//------------------------------------------------------------------------------------------------

varying vec2 f_src_pos;

uniform sampler2D u_texture;

void main() {
    vec4 color = texture2D(u_texture, f_src_pos);

    if (
        (is(c_root) && f_src_pos.y < 0.9) ||
        is(c_entities) ||
        is(c_blockentities) ||
        is(c_unspecified) ||
        is(c_debug) ||
        is(c_frame) ||
        is(c_extract) ||
        is(c_level) ||
        is(c_tick) ||
        is(c_piglin_brute) ||
        is(c_mob_spawner) ||
        is(c_vault) ||
        is(c_trial_spawner) ||
        is(c_bell) ||
        is(c_campfire) ||
        is(c_skull) ||
        is(c_sign)
    ) {
        gl_FragColor = color;
    } else {
        gl_FragColor = vec4(0.0);
    }
}
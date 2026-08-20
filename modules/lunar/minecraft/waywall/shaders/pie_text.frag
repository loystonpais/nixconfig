precision highp float;

#define RGB8(r,g,b)   (vec4((r)/255.0, (g)/255.0, (b)/255.0, 1.0))
#define RGBA8(r,g,b,a) (vec4((r)/255.0, (g)/255.0, (b)/255.0, (a)))

const vec4 entity_color = RGB8(228.0, 70.0, 196.0);
const vec4 unspecified_color = RGB8(70.0, 206.0, 102.0);
const vec4 blockentities_color = RGB8(236.0, 110.0, 78.0);
const vec4 mobspawner_color = RGB8(78.0, 228.0, 204.0);

//------------------------------------------------------------------------------------------------

varying vec2 f_src_pos;

uniform sampler2D u_texture;

const float threshold = 0.01;

const vec3 entities         = vec3(0.882, 0.271, 0.761);
const vec3 blockentities    = vec3(0.914, 0.427, 0.302);
const vec3 unspecified      = vec3(0.271, 0.796, 0.396);
const vec3 mobspawner       = vec3(0.302, 0.882, 0.792);

void main() {
    vec4 color = texture2D(u_texture, f_src_pos);

    bool is_entities = all(lessThan(abs(color.rgb - entities), vec3(threshold)));
    bool is_blockentities = all(lessThan(abs(color.rgb - blockentities), vec3(threshold)));
    bool is_unspecified = all(lessThan(abs(color.rgb - unspecified), vec3(threshold)));
    bool is_mobspawner = all(lessThan(abs(color.rgb - mobspawner), vec3(threshold)));

    if ( is_entities ) {
        gl_FragColor = entity_color;
    }
    else if ( is_unspecified ) {
        gl_FragColor = unspecified_color;
    }
    else if ( is_blockentities ) {
        gl_FragColor = blockentities_color;
    }
    else if ( is_mobspawner ) {
        gl_FragColor = mobspawner_color;
    }
    else {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
}
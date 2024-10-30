shader_type canvas_item;

uniform vec3 color1 : source_color = vec3(0.0, 0.2, 0.8);
uniform vec3 color2 : source_color = vec3(0.0, 0.4, 0.9);
uniform vec3 color3 : source_color = vec3(0.2, 0.6, 1.0);
uniform float wave_speed1 = 0.02;
uniform float wave_speed2 = 0.03;
uniform float wave_speed3 = 0.05;
uniform vec2 wave_direction1 = vec2(1.0, 0.5);
uniform vec2 wave_direction2 = vec2(-0.5, 1.0);
uniform vec2 wave_direction3 = vec2(0.7, -0.7);
uniform float noise_scale1 = 2.0;
uniform float noise_scale2 = 3.0;
uniform float noise_scale3 = 4.0;
uniform float pixelation_factor = 50.0; // Adjust this to control the blockiness

// Function to pixelate UV
vec2 pixelate(vec2 uv, float factor) {
    return floor(uv * factor) / factor;
}

vec2 random2(vec2 p) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43758.5453);
}

float seamless_noise(vec2 uv, float scale) {
    vec2 id = floor(uv * scale);
    vec2 f = fract(uv * scale);

    float min_dist = 1.0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = random2(mod(id + neighbor, scale));
            point = 0.5 + 0.5 * sin(6.2831 * point + TIME);
            vec2 diff = neighbor + point - f;
            float dist = length(diff);
            min_dist = min(min_dist, dist);
        }
    }
    return min_dist;
}

float fbm_seamless(vec2 uv, float scale) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < 5; i++) {
        value += amplitude * seamless_noise(uv, scale * frequency);
        amplitude *= 0.8;
        frequency *= 0.5;
    }
    return value;
}

void fragment() {
    vec2 base_uv = pixelate(SCREEN_UV, pixelation_factor);
    
    float noise1 = fbm_seamless(base_uv + wave_direction1 * TIME * wave_speed1, noise_scale1);
    float noise2 = fbm_seamless(base_uv + wave_direction2 * TIME * wave_speed2, noise_scale2);
    float noise3 = fbm_seamless(base_uv + wave_direction3 * TIME * wave_speed3, noise_scale3);
    
    vec3 water_color = mix(color1, color2, noise1);
    water_color = mix(water_color, color3, noise2 * 0.5);
    water_color += color3 * noise3 * 0.25;
    
    water_color += vec3(fbm_seamless(base_uv * 10.0, 5.0)) * 0.05;
    
    COLOR = vec4(water_color, 1.0);
}
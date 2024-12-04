shader_type canvas_item;

uniform float noise_strength : hint_range(0.0, 1.0) = 0.8;
uniform float noise_speed : hint_range(0.0, 10.0) = 5.0;
uniform vec2 resolution = vec2(164.0, 164.0); // Adjust for coarser/finer static

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Scale UV to create larger "pixels"
    vec2 scaled_uv = floor(SCREEN_UV * resolution) / resolution;

    // Add time-based offset for animation
    scaled_uv += TIME * noise_speed * 0.01;

    // Generate noise
    float noise = random(scaled_uv);

    // Apply noise strength
    noise = mix(0.5, noise, noise_strength);

    // Add some vertical scanlines
    float scanline = sin(SCREEN_UV.y * resolution.y * 2.0) * 0.1;
    noise -= scanline;

    // Convert to black and white
    COLOR = vec4(vec3(noise), 1.0);
}
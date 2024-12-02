shader_type canvas_item;

uniform float glow_spread : hint_range(0.0, 10.0) = 50.0;
uniform vec4 glow_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    
    // Calculate pulsing glow intensity
    float glow_intensity = mix(0.1, 0.5, (sin(TIME * PI / 2.5) + 1.0) / 2.0);
    
    // Create the glow effect
    float glow = 0.0;
    for(float x = -glow_spread; x < glow_spread; x++) {
        for(float y = -glow_spread; y < glow_spread; y++) {
            vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE;
            glow += texture(TEXTURE, UV + offset).a;
        }
    }
    
    glow = glow / (4.0 * glow_spread * glow_spread);
    
    // Combine original texture with glow
    vec3 final_glow = glow_color.rgb * glow * glow_intensity;
    COLOR.rgb = texture_color.rgb + final_glow;
    COLOR.a = texture_color.a;
}
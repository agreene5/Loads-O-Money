shader_type canvas_item;

uniform vec2 shadow_offset = vec2(0.0, 0.0);
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.5);
uniform float shadow_size = 1.5;
uniform float time_scale = 1.0;  // Controls the speed of the animation

uniform float shadow_skew_start = 0.0;
uniform float shadow_skew_end = 0.001;

float calculate_skew(float start, float end, float time) {
    float mid = (start + end) * 0.5;
    float half_range = (end - start) * 0.5;
    return mid + half_range * sin(time * 2.0 * PI * time_scale / 5.0);
}

void fragment() {
    vec4 original = texture(TEXTURE, UV);

    // Calculate shadow skew
    float shadow_skew = calculate_skew(shadow_skew_start, shadow_skew_end, TIME);

    // Calculate shadow position with skew
    vec2 shadow_uv = UV - shadow_offset * TEXTURE_PIXEL_SIZE * shadow_size;
    shadow_uv.x += shadow_uv.y * shadow_skew;

    // Sample the texture at the shadow position
    vec4 shadow = texture(TEXTURE, shadow_uv);

    // Create the shadow
    vec4 final_shadow = shadow_color;
    final_shadow.a *= shadow.a;

    // Blend the shadow with the background
    vec4 color = mix(final_shadow, vec4(0.0), step(shadow_uv.x, 0.0) + step(1.0, shadow_uv.x) + step(shadow_uv.y, 0.0) + step(1.0, shadow_uv.y));

    // Only apply the shadow, keep the original sprite unchanged
    COLOR = mix(color, original, original.a);
}
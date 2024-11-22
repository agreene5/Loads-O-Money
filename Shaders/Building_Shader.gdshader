shader_type canvas_item;

uniform float start_skew = 0.0; // Starting skew value
uniform float end_skew = 0.02;     // Ending skew value
uniform float time_cycle = 5.0;   // Time in seconds for one complete cycle

void vertex() {
    // Use cosine for smooth oscillation between -1 and 1
    float t = TIME / time_cycle;
    float cos_time = cos(t * 2.0 * 3.14159); // 2π for a full cycle

    // Map -1 to 1 range of cosine to our skew range
    float current_skew = mix(start_skew, end_skew, (cos_time + 1.0) * 0.5);

    // Apply skew in the X direction based on the Y position
    VERTEX.x += VERTEX.y * current_skew;
}

void fragment() {
    // Color the fragment
    COLOR = vec4(0.0, 0.0, 0.0, 0.5);
}
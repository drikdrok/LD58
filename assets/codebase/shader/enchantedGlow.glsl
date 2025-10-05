extern vec3 tint_color;
extern float time;      // current time in seconds
extern float base_strength; // base strength (like minimum tint)
extern float pulse_amplitude; // how much the strength pulses

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 pixel = Texel(texture, texture_coords) * color;
    vec3 tinted = pixel.rgb * tint_color;

    // Create a phase offset based on texture coordinates to vary pulse across texture
    float phase = texture_coords.x * 10.0 + texture_coords.y * 10.0;

    // Calculate pulsating strength between base_strength and base_strength + pulse_amplitude
    float pulse = base_strength + pulse_amplitude * (sin(time * 5.0 + phase) * 0.5 + 0.5);

    // Mix original and tinted color based on per-pixel pulse strength
    pixel.rgb = mix(pixel.rgb, tinted, pulse);

    return pixel;
}
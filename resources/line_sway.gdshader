shader_type canvas_item;

uniform float sway_speed : hint_range(0.1, 5.0) = 1.0; 
uniform float sway_strength : hint_range(0.0, 50.0) = 10.0;
uniform float noise_scale : hint_range(1.0, 20.0) = 5.0;
uniform float time_offset : hint_range(0.0, 100.0) = 0.0;

float noise1(float p, float t) {
    float n = sin(p * 2.0 + t * sway_speed) * 0.5;
    n += sin(p * 5.0 + t * sway_speed * 1.5) * 0.3;
    return n;
}

void vertex() {
    float instance_time = TIME + time_offset;
    
    // Displace vertices perpendicular to the line
    float displacement = noise1(VERTEX.x * 0.01 * noise_scale, instance_time) * sway_strength;
    VERTEX.y += displacement;
}

void fragment() {
    COLOR = texture(TEXTURE, UV);
}

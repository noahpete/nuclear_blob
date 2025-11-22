shader_type canvas_item;

uniform vec4 sky_color: source_color = vec4(1.0);
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 scene_color = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec4 light_texture = texture(TEXTURE, UV);
	float light_intensity = light_texture.a;
	vec3 light_color = light_texture.rgb;
	
	vec3 colored_scene = scene_color.rgb * sky_color.rgb;
	vec3 light_limit = scene_color.rgb - colored_scene;
	vec3 light_effect = light_limit * light_color * light_intensity;
	COLOR = vec4(min(colored_scene + light_effect, scene_color.rgb), scene_color.a);
}
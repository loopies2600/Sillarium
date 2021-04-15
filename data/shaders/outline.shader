shader_type canvas_item;

uniform float stroke : hint_range(0.0, 128.0);
uniform vec2 texSize;
uniform vec4 outline_color : hint_color;

void fragment()
{
	float width = stroke * 1.0 / texSize.x;
	float height = stroke * 1.0 / texSize.y;
	
	vec4 sprite_color = texture(TEXTURE, UV);
	float alpha = -8.0 * sprite_color.a;
	
	alpha += texture(TEXTURE, UV + vec2(width, 0.0)).a * outline_color.a;
	alpha += texture(TEXTURE, UV + vec2(-width, 0.0)).a * outline_color.a;
	alpha += texture(TEXTURE, UV + vec2(0.0, height)).a * outline_color.a;
	alpha += texture(TEXTURE, UV + vec2(0.0, -height)).a * outline_color.a;
	alpha += texture(TEXTURE, UV + vec2(width, height)).a * outline_color.a;
	alpha += texture(TEXTURE, UV + vec2(width, -height)).a * outline_color.a;
	alpha += texture(TEXTURE, UV + vec2(-width, height)).a * outline_color.a;
	alpha += texture(TEXTURE, UV + vec2(-width, -height)).a * outline_color.a;
	
	vec4 final_color = mix(sprite_color,outline_color, clamp(alpha, 0.0, 1.0));
	COLOR = vec4(final_color.rgb, clamp(abs(alpha) + sprite_color.a, 0.0, 1.0));
}
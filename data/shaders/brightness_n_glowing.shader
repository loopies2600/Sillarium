shader_type canvas_item;

uniform vec4 glowing_color : hint_color = vec4(1.0);
uniform vec4 secondary_glowing_color : hint_color = vec4(1.0);
uniform float brightness : hint_range(0, 8) = 1;
uniform float glowing_intensity : hint_range(0, 1) = 1;
uniform float precision : hint_range(0, 1) = 0.1;

void fragment(){
	COLOR = texture(TEXTURE,UV);
	
	if (distance(COLOR.rgba, glowing_color) >= precision && distance(COLOR.rgba, secondary_glowing_color) >= precision)
	{
		COLOR.rgb *= brightness;
	}
	else
	{
		COLOR.rgb *= glowing_intensity;
	}
}
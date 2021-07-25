shader_type canvas_item;

uniform bool invertColors = false;
uniform vec4 glowing_color : hint_color = vec4(1.0);
uniform vec4 secondary_glowing_color : hint_color = vec4(1.0);
uniform float brightness : hint_range(0, 8) = 1;
uniform float glowing_intensity : hint_range(0, 1) = 1;
uniform float precision : hint_range(0, 1) = 0.1;
uniform float opacity : hint_range(0, 1) = 1.0;

void fragment(){
	COLOR = texture(TEXTURE,UV);
	
	int x = int(FRAGCOORD.x) % 4;
	int y = int(FRAGCOORD.y) % 4;
	
	int index = x + y * 4;
	float limit = 0.0;
	
	if (x < 8) {
		if (index == 0) limit = 0.0625;
		if (index == 1) limit = 0.5625;
		if (index == 2) limit = 0.1875;
		if (index == 3) limit = 0.6875;
		if (index == 4) limit = 0.8125;
		if (index == 5) limit = 0.3125;
		if (index == 6) limit = 0.9375;
		if (index == 7) limit = 0.4375;
		if (index == 8) limit = 0.25;
		if (index == 9) limit = 0.75;
		if (index == 10) limit = 0.125;
		if (index == 11) limit = 0.625;
		if (index == 12) limit = 1.0;
		if (index == 13) limit = 0.5;
		if (index == 14) limit = 0.875;
		if (index == 15) limit = 0.375;
	}
	
	if (opacity < limit)
	    discard;
	
	if (distance(COLOR.rgba, glowing_color) >= precision && distance(COLOR.rgba, secondary_glowing_color) >= precision)
	{
		COLOR.rgb *= brightness;
	}
	else
	{
		COLOR.rgb *= glowing_intensity;
	}
	
	if (invertColors)
	{
		COLOR.rgb = vec3(1) - COLOR.rgb;
	}
}
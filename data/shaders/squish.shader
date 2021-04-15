shader_type canvas_item;

uniform bool uv_mode = false;
uniform float x_factor = 2.0;
uniform float bulge : hint_range(-1,1);

void vertex()
{
	VERTEX.x *= x_factor;
}

float bulge_function(float y)
{
	return sqrt(1.0 - y*y);
}

void fragment()
{
	vec2 uv = UV * 2.0 - 1.0;
	
	uv.x *= x_factor;
	
	float displacement = 1.0 + bulge * bulge_function(uv.y);
	uv.x /= displacement;
	
	uv = (uv + 1.0) / 2.0;
	
	if(uv_mode)
	{
		COLOR = uv.x >= 0.0 && uv.x <= 1.0 ? vec4(uv, 0.0, 1.0) : vec4(vec3(0.0), 1.0);
	}
	else
	{
		COLOR = texture(TEXTURE, uv)
	}
}
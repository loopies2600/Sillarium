shader_type canvas_item;
render_mode unshaded;

uniform float cutoff : hint_range(0.0, 1.0);
uniform float smoothSize : hint_range(0.0, 1.0);
uniform sampler2D mask : hint_albedo;

uniform bool reverse = false;

void fragment()
{
	float value = texture(mask, UV).r;
	
	if (reverse)
		{
			COLOR = vec4(COLOR.rgb, smoothstep(cutoff, cutoff + smoothSize, value));
		}
	else
		{
			COLOR = vec4(COLOR.rgb, smoothstep(value, value + smoothSize, cutoff));
		}
}
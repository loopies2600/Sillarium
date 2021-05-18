shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform float force;
uniform float size = 0.3;
uniform float thickness = 0.1;

void fragment(){
	float aspectRatio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(aspectRatio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size - (size / 4.0), size, length(scaledUV - center))) *
				 smoothstep(size - thickness - (size / 4.0), size - thickness, length(scaledUV - center));
	vec2 disp = normalize(scaledUV - center) * force * mask;
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
	COLOR.rgb = vec3(mask);
}
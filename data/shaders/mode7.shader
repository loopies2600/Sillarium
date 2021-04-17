shader_type canvas_item;

uniform vec2 DEPTH;
uniform vec2 POSITION;
uniform vec2 SCALE;
uniform bool REPEAT_X;
uniform bool REPEAT_Y;
uniform bool FLIP;
uniform bool toScreen;

void fragment() {
	mat4 TRANSFORM = mat4(0.0);
	TRANSFORM[0].x = SCALE.x;
	TRANSFORM[1].y = SCALE.y;
	TRANSFORM[3].x = POSITION.x;
	TRANSFORM[3].y = POSITION.y;
	mat4 mat = mat4(1.0);
	mat[0].w = DEPTH.x;
	mat[1].w = DEPTH.y;
	vec2 uv = UV * 2.0 - vec2(1, 1);
	// Turn position into 4d vector
	vec4 pos = vec4(uv, 1.0, 1.0);
	pos = mat * pos;
	pos.xy = pos.xy / pos.w;
	// Apply transformation to position
	float w = pos.w;
	pos.z = 0.0;
	pos.w = 1.0;
	// Apply depth to position
	pos = TRANSFORM * pos;
	// divide position by w coordinate; this applies perspective
	// Set UV to position; transform its range to [0, 1]
	uv = (pos.xy + vec2(1, 1)) * 0.5;
	// Determine if uv is in range or repeating pattern
	if (((uv.x > 0.0 && uv.x < 1.0) || REPEAT_X) && ((uv.y > 0.0 && uv.y < 1.0) || REPEAT_Y) && (w > 0.0 || FLIP)) {
		// Apply texture
		uv = mod(uv, 1.0);
		
		if (toScreen) {
			COLOR = textureLod(SCREEN_TEXTURE, uv, 0.0);
		} else {
			COLOR = texture(TEXTURE, uv);
		}
	} else {
		COLOR = vec4(0, 0, 0, 0);
	}
}
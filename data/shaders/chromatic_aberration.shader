shader_type canvas_item;

uniform float redOffsetX = 8;
uniform float redOffsetY = 8;

uniform float blueOffsetX = 8;
uniform float blueOffsetY = 8;

void fragment(){
	vec4 redChannel = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x + (redOffsetX * SCREEN_PIXEL_SIZE.x), SCREEN_UV.y + (redOffsetY * SCREEN_PIXEL_SIZE.y)));
	vec4 greenChannel = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 blueChannel = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x - (blueOffsetX * SCREEN_PIXEL_SIZE.x), SCREEN_UV.y + (blueOffsetY * SCREEN_PIXEL_SIZE.y)));
	
	COLOR = vec4(redChannel.r, greenChannel.g, blueChannel.b, 1.0);
	
}
shader_type canvas_item;

uniform float amount : hint_range(0, 5);
uniform vec4 tint : hint_color = vec4(1.0);
uniform float tintAmount : hint_range(0, 1);

void fragment() {
	// BLUR GETS UNUSED SINCE WEB VERSION WILL GONNA B WEBGL 1 AND IT LAGS A LOT
	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, amount).rgb;
	COLOR.rgb = mix(COLOR.rgb, tint.rgb, tintAmount);
}
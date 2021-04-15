shader_type canvas_item;

const int EFFECT_TYPE_DREAMY = 0;
const int EFFECT_TYPE_WAVY = 1;
const int EFFECT_TYPE_HEAT_WAVE_HORIZONTAL = 2;
const int EFFECT_TYPE_HEAT_WAVE_VERTICAL = 3;
const int EFFECT_TYPE_FLAG = 4;

uniform bool toScreen;
uniform int effectType : hint_range(0, 4);

uniform float uSpeed;
uniform float uFrequency;
uniform float uWaveAmplitude;

vec2 sineWave(vec2 pt, float time) {
	float x = 0.0;
	float y = 0.0;
	
	if (effectType == EFFECT_TYPE_DREAMY) {
		float offsetX = sin(pt.y * uFrequency + time * uSpeed) * uWaveAmplitude;
		pt.x += offsetX // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
	}
	else if (effectType == EFFECT_TYPE_WAVY) 
	{
		float offsetY = sin(pt.x * uFrequency + time * uSpeed) * uWaveAmplitude;
		pt.y += offsetY; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
	}
	else if (effectType == EFFECT_TYPE_HEAT_WAVE_HORIZONTAL)
	{
		x = sin(pt.x * uFrequency + time * uSpeed) * uWaveAmplitude;
	}
	else if (effectType == EFFECT_TYPE_HEAT_WAVE_VERTICAL)
	{
		y = sin(pt.y * uFrequency + time * uSpeed) * uWaveAmplitude;
	}
	else if (effectType == EFFECT_TYPE_FLAG)
	{
		y = sin(pt.y * uFrequency + 10.0 * pt.x + time * uSpeed) * uWaveAmplitude;
		x = sin(pt.x * uFrequency + 5.0 * pt.y + time * uSpeed) * uWaveAmplitude;
	}
	
	return vec2(pt.x + x, pt.y + y);
}

void fragment() {
	if (toScreen) {
		COLOR = textureLod(SCREEN_TEXTURE, sineWave(UV, TIME), 0.0);
	}
	else {
		COLOR = texture(TEXTURE, sineWave(UV, TIME));
	}
}
shader_type canvas_item;

uniform int lightAmount = 2;

uniform float alphaPad = 0.75;
uniform float speed = 3.0;

uniform vec2 intensity = vec2(2.0, 1.0);
uniform vec2 widths = vec2(0.02, 0.08);

uniform vec4 fillColor : hint_color = vec4(1.0);
uniform vec4 outlineColor : hint_color = vec4(0.5, 0.5, 1.0, 1.0);

float plot(vec2 st, float pct, float halfWidth) {
	return smoothstep(pct + halfWidth, pct, st.y) - smoothstep(pct, pct - halfWidth, st.y);
}

float rand(vec2 n) {
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 n) {
	vec2 d = vec2(0.0, 1.0);
	vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
	return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

float fbm(vec2 n) {
	float total = 0.0, amplitude = 1.0;
	for (int i = 0; i < 7; i++) {
		total += noise(n) * amplitude;
		n += n;
		amplitude *= 0.5;
	}
	return total;
}

void fragment() {
	vec4 color = vec4(0.0);
	
	vec2 t;
	float y;
	float pct;
	float buffer;

	for (int i = 0; i < lightAmount; i++) {
		t = UV * intensity + vec2(float(i), -float(i))- TIME * speed;
		y = fbm(t) * 0.5;
		pct = plot(UV, y, widths.x);
		buffer = plot(UV, y, widths.y);
	
		color += pct * fillColor;
		color += buffer * outlineColor;
	}
	
	if (color.a > alphaPad) {
		color.a = 1.0;
	}
	else {
		color.a = 0.0;
	}
	
	COLOR = color;
}
shader_type canvas_item;

// Ombres de nuages qui glissent sur le sol : un bruit lisse qui se deplace,
// coupe net (pas de degrade) avec une bordure plus claire d'un cran.
// Calcule en pixels du monde pour rester aligne sur la grille.

uniform vec4 shade : source_color = vec4(0.04, 0.04, 0.14, 0.17);
uniform vec2 wind = vec2(5.0, 1.5);
uniform float scale = 110.0;
uniform float coverage = 0.6;

varying vec2 world_pos;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x), mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x), f.y);
}

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec2 p = (floor(world_pos) - floor(TIME * wind)) / scale;
	float n = noise(p) * 0.65 + noise(p * 2.3 + 7.1) * 0.35;
	COLOR = vec4(0.0);
	if (n > coverage + 0.03) {
		COLOR = shade;
	} else if (n > coverage) {
		COLOR = vec4(shade.rgb, shade.a * 0.5);
	}
}

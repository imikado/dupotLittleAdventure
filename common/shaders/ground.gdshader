shader_type canvas_item;

// Sol (herbe, sable) : casse la repetition des tuiles de fond avec de grandes
// zones plus claires/plus sombres et, pour l'herbe, quelques fleurs semees au
// hasard. Tout est calcule en pixels du monde, donc reste aligne sur la grille.

uniform float patch_size = 140.0;
uniform float patch_strength = 0.07;
// taille d'une case de semis de fleurs (en pixels) et probabilite d'une fleur
uniform float flower_cell = 20.0;
uniform float flower_density = 0.0;
uniform vec3 flower_color_a : source_color = vec3(0.96, 0.95, 0.88);
uniform vec3 flower_color_b : source_color = vec3(0.98, 0.84, 0.32);
uniform vec3 flower_color_c : source_color = vec3(0.76, 0.6, 0.9);
uniform vec3 flower_heart : source_color = vec3(0.95, 0.72, 0.2);

varying vec2 world_pos;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float value_noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec2 pixel = floor(world_pos);

	// grandes zones de lumiere, posterisees en 3 paliers pour rester "pixel art"
	float n = value_noise(pixel / patch_size) * 0.65 + value_noise(pixel / (patch_size * 0.37) + 17.0) * 0.35;
	float level = floor(n * 3.0) - 1.0;
	color.rgb *= 1.0 + level * patch_strength;

	if (flower_density > 0.0) {
		vec2 cell = floor(pixel / flower_cell);
		if (hash(cell + 3.1) < flower_density) {
			// position de la fleur dans sa case, a distance des bords
			vec2 center = cell * flower_cell + 2.0 + floor(vec2(hash(cell + 7.3), hash(cell + 9.7)) * (flower_cell - 4.0));
			vec2 d = pixel - center;
			float pick = hash(cell + 1.7);
			vec3 petal = pick < 0.45 ? flower_color_a : (pick < 0.8 ? flower_color_b : flower_color_c);
			if (d == vec2(0.0)) {
				color.rgb = flower_heart;
			} else if (abs(d.x) + abs(d.y) == 1.0) {
				color.rgb = petal;
			} else if (d == vec2(0.0, 2.0) || d == vec2(1.0, 2.0)) {
				// petite ombre portee sous la fleur
				color.rgb *= 0.8;
			}
		}
	}
	COLOR = color;
}

shader_type canvas_item;

// Mer : de petits reflets clairs apparaissent et disparaissent a la surface,
// seulement sur l'eau (pas sur l'ecume ni le sable mouille). Tout est calcule
// en pixels du monde, donc les reflets restent alignes sur la grille.

uniform vec3 water_a : source_color = vec3(0.204, 0.463, 0.745);
uniform vec3 water_b : source_color = vec3(0.259, 0.541, 0.808);
uniform vec3 glint : source_color = vec3(0.588, 0.769, 0.925);
// taille d'une case (un reflet au plus par case) et part des cases allumees
uniform vec2 cell = vec2(18.0, 10.0);
uniform float density = 0.3;
uniform float speed = 0.8;

varying vec2 world_pos;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	bool water = distance(color.rgb, water_a) < 0.03 || distance(color.rgb, water_b) < 0.03;
	if (water) {
		vec2 pixel = floor(world_pos);
		vec2 id = floor(pixel / cell);
		// chaque case change d'etat a son propre rythme
		float step_time = floor(TIME * speed + hash(id + 5.3) * 8.0);
		if (hash(id + step_time * 1.37) < density) {
			vec2 start = id * cell + 2.0 + floor(vec2(hash(id + step_time + 2.1), hash(id + step_time + 4.7)) * (cell - 6.0));
			vec2 d = pixel - start;
			float len = hash(id + 9.1) < 0.5 ? 2.0 : 3.0;
			if (d.y == 0.0 && d.x >= 0.0 && d.x < len) {
				color.rgb = glint;
			}
		}
	}
	COLOR = color;
}

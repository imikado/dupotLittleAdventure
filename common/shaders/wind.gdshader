shader_type canvas_item;

// Vent dans la vegetation : le haut du sprite se balance de quelques pixels
// (pas entiers) alors que le pied reste fixe. Chaque plante a sa propre phase
// selon sa position dans le monde.

uniform float amplitude = 1.0;
uniform float speed = 1.6;
// part du sprite (depuis le bas) qui ne bouge pas
uniform float anchor = 0.35;

// position du coin haut-gauche de la texture : la meme pour tout le sprite
varying vec2 sprite_origin;

void vertex() {
	sprite_origin = (MODEL_MATRIX * vec4(VERTEX - UV / TEXTURE_PIXEL_SIZE, 0.0, 1.0)).xy;
}

void fragment() {
	// hauteur dans la texture : 0 en bas, 1 en haut (une texture par plante)
	float height = clamp((1.0 - UV.y - anchor) / (1.0 - anchor), 0.0, 1.0);
	float phase = sprite_origin.x * 0.053 + sprite_origin.y * 0.031;
	float sway = sin(TIME * speed + phase) + 0.4 * sin(TIME * speed * 2.3 + phase * 1.3);
	float shift = round(sway * amplitude * height * height);
	vec2 uv = UV - vec2(shift * TEXTURE_PIXEL_SIZE.x, 0.0);
	vec4 color = texture(TEXTURE, uv);
	// ne pas aller chercher de pixels hors du sprite
	if (uv.x < 0.0 || uv.x > 1.0) {
		color.a = 0.0;
	}
	COLOR = color;
}

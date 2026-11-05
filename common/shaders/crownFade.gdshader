shader_type canvas_item;

// Estompe la couronne d'un arbre (tuile de 256 px de haut) quand Gordon passe
// derriere : le pied de l'arbre est plus bas que les pieds de Gordon.
// Alpha par paliers sur la grille des pixels du monde, pour rester net.

uniform vec2 playerPos;
// position du pied dans la tuile ; seules les textures plus hautes que
// minTreeHeight sont estompees (la texture des tuiles est rembourree d'un
// pixel par le TileSet : 258 px de haut pour des arbres de 256)
uniform float minTreeHeight = 200.0;
uniform float footY = 240.0;
// decalage des pieds de Gordon par rapport a sa position
uniform float playerFeet = 14.0;
uniform vec2 innerRadius = vec2(13.0, 17.0);
uniform vec2 outerRadius = vec2(17.0, 21.0);
uniform float innerAlpha = 0.4;
uniform float outerAlpha = 0.7;

varying vec2 worldPos;
varying float treeFoot;

void vertex() {
	vec2 world = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	worldPos = world;
	// haut de la tuile : la meme valeur pour les 4 coins
	treeFoot = world.y - UV.y / TEXTURE_PIXEL_SIZE.y + footY;
}

void fragment() {
	vec4 color = texture(TEXTURE, UV) * COLOR;
	// seules les tuiles d'arbre sont concernees (pas les buissons du calque)
	if (1.0 / TEXTURE_PIXEL_SIZE.y > minTreeHeight && treeFoot > playerPos.y + playerFeet) {
		vec2 delta = floor(worldPos) + vec2(0.5) - playerPos;
		vec2 inner = delta / innerRadius;
		vec2 outer = delta / outerRadius;
		if (dot(inner, inner) <= 1.0) {
			color.a *= innerAlpha;
		} else if (dot(outer, outer) <= 1.0) {
			color.a *= outerAlpha;
		}
	}
	COLOR = color;
}

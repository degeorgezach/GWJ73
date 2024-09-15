shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
const int pixel_size = 8;


void vertex() {
	// Called for every vertex the material is visible on.
}



void fragment() {	
	// a variant of nearest neighbour fragment shader
	float x = float(int (FRAGCOORD.x) % pixel_size);
	float y = float(int (FRAGCOORD.y) % pixel_size);
	
	x = FRAGCOORD.x + floor (float(pixel_size) / 2.0) - x;
	y = FRAGCOORD.y + floor (float(pixel_size) / 2.0) - y;
	
	// set albedo value on the current coordinate based on vec2(x,y) / viewport_size
	ALBEDO = texture (SCREEN_TEXTURE, vec2(x, y) / VIEWPORT_SIZE).xyz;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}

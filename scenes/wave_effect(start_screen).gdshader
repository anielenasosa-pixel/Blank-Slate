shader_type canvas_item;

uniform float wave_speed : hint_range(0.0, 10.0) = 3.0;
uniform float wave_frequency : hint_range(0.0, 50.0) = 15.0;
uniform float wave_amplitude : hint_range(0.0, 50.0) = 5.0;


void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.y += sin(TIME * wave_speed + VERTEX.x * wave_frequency) * wave_amplitude;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

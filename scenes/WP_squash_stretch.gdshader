shader_type canvas_item;
uniform float max_squash: hint_range(0.0, 0.5)=0.25;
uniform float squash_progress: hint_range(-1.0,1.0)=0.0;

void vertex() {
	float scale_y= 1.0+(squash_progress*max_squash);
	float scale_x= 1.0/scale_y;
	float texture_height=1.0/TEXTURE_PIXEL_SIZE.y;
	float bottom_y=texture_height*0.5;
	VERTEX.x*=scale_x;
	VERTEX.y = (VERTEX.y - bottom_y) * scale_y + bottom_y;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

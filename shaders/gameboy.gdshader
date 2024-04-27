shader_type canvas_item;

uniform vec4 lightest : source_color;
uniform vec4 light : source_color;
uniform vec4 dark : source_color;
uniform vec4 darkest : source_color;

uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);
	float rgb_avg = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
	if (rgb_avg < .25) {
		COLOR = darkest;
	} else if (rgb_avg < .5) {
		COLOR = dark;
	} else if (rgb_avg < .75) {
		COLOR = light;
	} else {
		COLOR = lightest;
	}
}
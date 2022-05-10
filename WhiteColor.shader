// spatial for 3d
shader_type canvas_item;

uniform bool active = true;

void fragment()
// built-in, executes on every pixels
{ // avoid if in shaders
	vec4 previous_color = texture(TEXTURE, UV); // access pixels on the texture/sprite, and position
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a); // alpha of transparent pixels are 0
	vec4 new_color = previous_color;
	if (active)
	{
		new_color = white_color;
	}
	COLOR = new_color;
}
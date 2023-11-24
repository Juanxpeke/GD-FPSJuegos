shader_type canvas_item;

uniform bool monochrome;

float circle(vec2 position, float radius, float feather)
{
	return smoothstep(radius, radius + feather, length(position - vec2(0.5)));
}

void fragment()
{
	COLOR.a = 1.0 - circle(UV, 0.5, 0.005);
	
	if (monochrome)
	{
		float avg = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
    	COLOR.rgb = vec3(avg);
	}
}

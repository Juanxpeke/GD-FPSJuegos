shader_type canvas_item;

uniform bool bordered;
uniform bool monochrome;

float circle(vec2 position, float radius, float feather)
{
	return smoothstep(radius, radius + feather, length(position - vec2(0.5)));
}

void fragment()
{
	COLOR.a = 1.0 - circle(UV, 0.5, 0.005);
	
	if (bordered)
	{
		vec4 border_color = vec4(1.0, 1.0, 1.0, 1.0);
		vec4 border_transparent_color = vec4(border_color.rgb, 0.0);
		vec4 anim_border_color = mix(border_transparent_color, border_color, abs(sin(TIME * 1.0)));
		
		float size_x = 1.0 / float(textureSize(TEXTURE, 0).x);
		float size_y = 1.0 / float(textureSize(TEXTURE, 0).y);
		
		float alpha = -4.0 * COLOR.a;
		alpha += 1.0 - circle(UV + vec2(size_x, 0), 0.5, 0.005);
		alpha += 1.0 - circle(UV + vec2(-size_x, 0), 0.5, 0.005);
		alpha += 1.0 - circle(UV + vec2(0, size_y), 0.5, 0.005);
		alpha += 1.0 - circle(UV + vec2(0, -size_y), 0.5, 0.005);;
		
		vec4 final_color = mix(COLOR, anim_border_color, clamp(alpha, 0.0, 1.0));
		COLOR = final_color;
	}
	else if (monochrome)
	{
		float average_color = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
		float average_decresed_color = average_color * 0.6;
    	COLOR.rgb = vec3(average_decresed_color);
	}
}

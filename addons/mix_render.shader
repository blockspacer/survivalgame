shader_type canvas_item;

uniform sampler2D sky : hint_albedo;
uniform sampler2D clouds : hint_albedo;

void fragment(){
		
		vec4 clouds_frag = textureLod(clouds, UV, 1.0);
		vec4 sky_frag = textureLod(sky, UV, 1.0);
		
		COLOR = clouds_frag;
    	//COLOR = mix(sky_frag, clouds_frag, clouds_frag.a);
		
		
		
		if (COLOR == vec4(1.)){
			COLOR = vec4((sin(TIME)/2.)+1.,.5,1.,1.);
		}
		
	}
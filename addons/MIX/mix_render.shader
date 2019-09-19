shader_type canvas_item;

uniform sampler2D sky : hint_albedo;
uniform sampler2D clouds : hint_albedo;

void fragment(){
		
		vec2 iResolution=1./TEXTURE_PIXEL_SIZE;
		
		vec4 clouds_frag = texture(clouds, UV*iResolution);
		vec4 sky_frag = texture(sky, UV);
		
		COLOR = clouds_frag;
    	//COLOR = mix(sky_frag, clouds_frag, clouds_frag.a);
		
		if (COLOR == vec4(1.)){
			COLOR = vec4((sin(TIME)/2.)+0.5,.5,1.,1.);
		}
		
	}
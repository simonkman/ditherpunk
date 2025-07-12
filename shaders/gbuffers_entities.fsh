#version 330 compatibility

#include /lib/settings.glsl

uniform sampler2D lightmap;
uniform sampler2D gtexture;
uniform vec4 entityColor;

uniform float alphaTestRef = 0.1;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 10,3 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 cutouts; // cutouts to break up image later

void main() {
	color = texture(gtexture, texcoord) * glcolor;
	color.rgb = mix(color.rgb, entityColor.rgb, entityColor.a);
	color *= texture(lightmap, lmcoord);
	if (color.a < alphaTestRef) {
		discard;
	}
  #if GBUFFERS_ENTITIES_LAYER == 1
  cutouts = vec4(1, 0, 0, 1);
  #endif
  #if GBUFFERS_ENTITIES_LAYER == 2
  cutouts = vec4(0, 1, 0, 1);
  #endif
  #if GBUFFERS_ENTITIES_LAYER == 3
  cutouts = vec4(0, 0, 1, 1);
  #endif
}

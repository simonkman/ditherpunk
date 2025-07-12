#version 330 compatibility

#include /lib/settings.glsl
#include /lib/edge_layers.glsl

uniform sampler2D gtexture;

uniform float alphaTestRef = 0.1;

in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0,2,1 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 cutouts; // cutouts to break up image later
layout(location = 2) out vec4 edgeLayers; // copy for sobel filter

void main() {
	color = texture(gtexture, texcoord) * glcolor;
	if (color.a < alphaTestRef) {
		discard;
	}
  #if GBUFFERS_SKYTEXTURED_LAYER == 1
  cutouts = vec4(1, 0, 0, 1);
  #endif
  #if GBUFFERS_SKYTEXTURED_LAYER == 2
  cutouts = vec4(0, 1, 0, 1);
  #endif
  #if GBUFFERS_SKYTEXTURED_LAYER == 3
  cutouts = vec4(0, 0, 1, 1);
  #endif
  // this creates a weird halo around the sun/moon and it looks weird
  // edgeLayers = skytextured;
}

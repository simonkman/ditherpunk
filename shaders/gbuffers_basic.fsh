#version 330 compatibility

#include /lib/settings.glsl
#include /lib/edge_layers.glsl

uniform sampler2D lightmap;

uniform float alphaTestRef = 0.1;

in vec2 lmcoord;
in vec4 glcolor;
in vec3 normal;

/* RENDERTARGETS: 0,2,1,12 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 layermask; // layermask to break up image later
layout(location = 2) out vec4 edgeLayers; // copy for sobel filter
layout(location = 3) out vec4 encodedNormal;

void main() {
	color = glcolor * texture(lightmap, lmcoord);
	if (color.a < alphaTestRef) {
		discard;
	}
  #if GBUFFERS_BASIC_LAYER == 1
  layermask = vec4(1, 0, 0, 1);
  #endif
  #if GBUFFERS_BASIC_LAYER == 2
  layermask = vec4(0, 1, 0, 1);
  #endif
  #if GBUFFERS_BASIC_LAYER == 3
  layermask = vec4(0, 0, 1, 1);
  #endif
  encodedNormal = vec4(normal * 0.5 + 0.5, 1.0);
  edgeLayers = basic;
}

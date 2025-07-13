#version 330 compatibility

#include /lib/settings.glsl
#include /lib/util.glsl

uniform sampler2D depthtex0;
uniform sampler2D colortex0;

uniform float near;
uniform float far;

in vec2 texcoord;

/* RENDERTARGETS: 0,11 */
layout(location = 0) out vec4 color;
layout(location = 1) out float depth;

void main() {
	color = texture(colortex0, texcoord);
  // need depth to be linear for sobel filter stuff
  depth = linearizeDepth(texture(depthtex0, texcoord).r, near, far);
  float depthThreshold = step(EDGE_DEPTH_THRESHOLD, depth);
  depth = depth * (1 - depthThreshold) + depthThreshold;
}

#version 330 compatibility

#include /lib/settings.glsl
#include /lib/util.glsl

uniform sampler2D depthtex0;
uniform sampler2D colortex0;
uniform sampler2D colortex12; // normals

uniform float near;
uniform float far;

in vec2 texcoord;

/* RENDERTARGETS: 0,11,12 */
layout(location = 0) out vec4 color;
layout(location = 1) out float depth;
layout(location = 2) out vec4 normals;

void main() {
	color = texture(colortex0, texcoord);

  // need depth to be linear for sobel filter stuff
  depth = linearizeDepth(texture(depthtex0, texcoord).r, near, far);

  // grayscale normals bcuz sobel needs grayscale
  normals = texture(colortex12, texcoord);
  #ifndef DISPLAY_NORMALS
  normals.rgb = vec3(luminance(normals.rgb));
  #endif
}

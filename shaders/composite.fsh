#version 330 compatibility

#include "/lib/settings.glsl"
#include "/lib/util.glsl"

uniform sampler2D depthtex0;
uniform sampler2D colortex0;
uniform sampler2D colortex2;  // layermask for opaque compositing, layers (1,2,3) are the (r,g,b) components
uniform sampler2D colortex12; // normals
#ifdef PRE_BLEND_ALPHA
uniform sampler2D colortex10; // transparent pass, was supposed to be colortex1 but alpha wasn't working on it?
uniform sampler2D colortex3;  // layermask for transparent compositing, layers (1,2,3) are the (r,g,b) components
#endif

uniform float near;
uniform float far;

in vec2 texcoord;

/* RENDERTARGETS: 0,11,12,2 */
layout(location = 0) out vec4 color;
layout(location = 1) out float depth;
layout(location = 2) out vec4 normals;
layout(location = 3) out vec4 layermask;

void main() {
	color = texture(colortex0, texcoord);
  layermask = texture(colortex2, texcoord);

  // need depth to be linear for sobel filter stuff
  depth = linearizeDepth(texture(depthtex0, texcoord).r, near, far);

  // grayscale normals bcuz sobel needs grayscale
  normals = texture(colortex12, texcoord);
  #ifndef DISPLAY_NORMALS
  normals.rgb = vec3(luminance(normals.rgb));
  #endif

  #ifdef PRE_BLEND_ALPHA
  // alpha blend transparent render passes
  vec4 trans = texture(colortex10, texcoord);
  color.rgb = color.rgb * (1 - trans.a) + trans.rgb;
  // alpha blend transparent layermask
  vec4 transLayermask =  texture(colortex3, texcoord);
  layermask.rgb = layermask.rgb * (1 - transLayermask.a) + transLayermask.rgb;
  #endif
}

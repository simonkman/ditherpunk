#version 330 compatibility

#include "/lib/settings.glsl"

uniform mat4 gbufferModelViewInverse;

out vec2 lmcoord;
out vec2 texcoord;
out vec4 glcolor;
out vec3 normal;

#ifdef DISABLE_LEAVES_TRANSPARENCY
in vec2 mc_Entity;
flat out float blockId;
#endif

void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;
  normal = gl_NormalMatrix * gl_Normal;
  normal = mat3(gbufferModelViewInverse) * normal;
  #ifdef DISABLE_LEAVES_TRANSPARENCY
  blockId = mc_Entity.x;
  #endif
}

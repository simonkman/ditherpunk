#version 330 compatibility

uniform mat4 gbufferModelViewInverse;

out vec2 texcoord;
out vec4 glcolor;
out vec3 normal;

void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	glcolor = gl_Color;
  normal = gl_NormalMatrix * gl_Normal;
  normal = mat3(gbufferModelViewInverse) * normal;
}

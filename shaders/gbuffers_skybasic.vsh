#version 330 compatibility

uniform mat4 gbufferModelViewInverse;

out vec4 glcolor;
out vec3 normal;

void main() {
	gl_Position = ftransform();
	glcolor = gl_Color;
  normal = gl_NormalMatrix * gl_Normal;
  normal = mat3(gbufferModelViewInverse) * normal;
}

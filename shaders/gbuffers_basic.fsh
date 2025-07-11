#version 330 compatibility

uniform sampler2D lightmap;

uniform float alphaTestRef = 0.1;

in vec2 lmcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0,3 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 colorcopy; // copy to do processing to later separately

void main() {
	color = glcolor * texture(lightmap, lmcoord);
	if (color.a < alphaTestRef) {
		discard;
	}
  colorcopy = color;
}

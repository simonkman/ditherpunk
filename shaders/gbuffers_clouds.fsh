#version 330 compatibility

uniform sampler2D gtexture;

uniform float alphaTestRef = 0.1;

in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0,2,4 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 colorcopy; // copy to do processing to later separately
layout(location = 2) out vec4 depth; // write to channel 2 for later processing

void main() {
	color = texture(gtexture, texcoord) * glcolor;
	if (color.a < alphaTestRef) {
		discard;
	}
  colorcopy = color;
  depth.g = gl_FragCoord.z;
}

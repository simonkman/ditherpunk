#version 330 compatibility

#include "/lib/settings.glsl"
#include "/lib/edge_layers.glsl"

uniform int renderStage;
uniform float viewHeight;
uniform float viewWidth;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjectionInverse;
uniform vec3 fogColor;
uniform vec3 skyColor;

in vec4 glcolor;
in vec3 normal;

float fogify(float x, float w) {
	return w / (x * x + w);
}

vec3 calcSkyColor(vec3 pos) {
	float upDot = dot(pos, gbufferModelView[1].xyz); //not much, what's up with you?
	return mix(skyColor, fogColor, fogify(max(upDot, 0.0), 0.25));
}

vec3 screenToView(vec3 screenPos) {
	vec4 ndcPos = vec4(screenPos, 1.0) * 2.0 - 1.0;
	vec4 tmp = gbufferProjectionInverse * ndcPos;
	return tmp.xyz / tmp.w;
}

/* RENDERTARGETS: 0,2,1,12 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 layermask; // layermask to break up image later
layout(location = 2) out vec4 edgeLayers; // copy for sobel filter
layout(location = 3) out vec4 encodedNormal;

void main() {
	if (renderStage == MC_RENDER_STAGE_STARS) {
		color = glcolor;
	} else {
		vec3 pos = screenToView(vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), 1.0));
		color = vec4(calcSkyColor(normalize(pos)), 1.0);
	}
  #if GBUFFERS_SKYBASIC_LAYER == 1
  layermask = vec4(1, 0, 0, 1);
  #endif
  #if GBUFFERS_SKYBASIC_LAYER == 2
  layermask = vec4(0, 1, 0, 1);
  #endif
  #if GBUFFERS_SKYBASIC_LAYER == 3
  layermask = vec4(0, 0, 1, 1);
  #endif
  encodedNormal = vec4(normal * 0.5 + 0.5, 1.0);
  edgeLayers = skybasic;
}

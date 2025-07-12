#version 330 compatibility

#include /lib/settings.glsl
#include /lib/convolution.glsl

uniform sampler2D colortex0;
uniform sampler2D colortex11;

in vec2 texcoord;

const float edgeThreshold = EDGE_THRESHOLD / 255.0;
const vec4 lightEdgeColor = vec4(EDGE_LIGHT_R / 255.0,
                                 EDGE_LIGHT_G / 255.0,
                                 EDGE_LIGHT_B / 255.0,
                                 1);
const vec4 darkEdgeColor  = vec4(EDGE_DARK_R  / 255.0,
                                 EDGE_DARK_G  / 255.0,
                                 EDGE_DARK_B  / 255.0,
                                 1);

/* RENDERTARGETS: 0,11 */
layout(location = 0) out vec4 color;
layout(location = 1) out float edges;

void main() {
  // compute the edges of image
  // i.e. the magnitude of the gradient in x and y directions
  vec2 grad;
  grad.x = grayConvolve3(sobelX, colortex11, gl_FragCoord.xy);
  grad.y = grayConvolve3(sobelY, colortex11, gl_FragCoord.xy);
  edges = length(grad) * sobelScale;

  // compute edge color
  float edgeColorSwitch = step(edgeThreshold, texture(colortex11, texcoord).r);
  vec4 edgeColor       = darkEdgeColor * edgeColorSwitch + lightEdgeColor * (1 - edgeColorSwitch);

  // composite edges over image
  color = texture(colortex0, texcoord);
  float edgeSwitch = step(edgeThreshold, edges);
  color = edgeColor * edgeSwitch + color * (1 - edgeSwitch);
}

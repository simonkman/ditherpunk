#version 330 compatibility

#include /lib/settings.glsl
#include /lib/dither.glsl
#include /lib/util.glsl
#include /lib/convolution.glsl

uniform sampler2D colortex0;  // all opaque passes
uniform sampler2D colortex1;  // layers/cutouts for sobel filter edges
uniform sampler2D colortex10; // transparent pass, was supposed to be colortex1 but alpha wasn't working on it?
uniform sampler2D colortex2;  // cutouts for opaque compositing, layers (1,2,3) are the (r,g,b) components
uniform sampler2D colortex3;  // cutouts for transparent compositing, layers (1,2,3) are the (r,g,b) components
uniform sampler2D colortex4;  // blue noise
uniform sampler2D noisetex;   // white noise

uniform float viewHeight;
uniform float viewWidth;

/*
const int colortex1Format  = R8;
const int colortex4Format  = RGB8;
const int colortex11Format = R16;
*/

in vec2 texcoord;
layout(pixel_center_integer) in vec4 gl_FragCoord;

const float edgeThreshold = EDGE_DARK_LIGHT_THRESHOLD / 255.0;
const vec4 lightEdgeColor = vec4(EDGE_LIGHT_R / 255.0,
                                 EDGE_LIGHT_G / 255.0,
                                 EDGE_LIGHT_B / 255.0,
                                 1);
const vec4 darkEdgeColor  = vec4(EDGE_DARK_R  / 255.0,
                                 EDGE_DARK_G  / 255.0,
                                 EDGE_DARK_B  / 255.0,
                                 1);

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// ==========DITHER FUNCTIONS==========
// dither functions for each layer

float layerOneDither(vec2 pos) {
 #if LAYER_ONE_DITHER == DITHER_WHITENOISE
  return texelFetch(noisetex, ivec2(mod(pos, vec2(NOISE_SIZE))), 0).r;
  #endif
  #if LAYER_ONE_DITHER == DITHER_BLUENOISE
  return texelFetch(colortex4, ivec2(mod(pos, vec2(NOISE_SIZE))), 0).r;
  #endif
  #if LAYER_ONE_DITHER == DITHER_BAYER
    #if LAYER_ONE_BAYER_SIZE == 2
    return bayer2(pos);
    #endif
    #if LAYER_ONE_BAYER_SIZE == 4
    return bayer4(pos);
    #endif
    #if LAYER_ONE_BAYER_SIZE == 8
    return bayer8(pos);
    #endif
    #if LAYER_ONE_BAYER_SIZE == 16
    return bayer16(pos);
    #endif
  #endif

  return 0.5; // fallback
}

float layerTwoDither(vec2 pos) {
 #if LAYER_TWO_DITHER == DITHER_WHITENOISE
  return texelFetch(noisetex, ivec2(mod(pos, vec2(NOISE_SIZE))), 0).r;
  #endif
  #if LAYER_TWO_DITHER == DITHER_BLUENOISE
  return texelFetch(colortex4, ivec2(mod(pos, vec2(NOISE_SIZE))), 0).r;
  #endif
  #if LAYER_TWO_DITHER == DITHER_BAYER
    #if LAYER_TWO_BAYER_SIZE == 2
    return bayer2(pos);
    #endif
    #if LAYER_TWO_BAYER_SIZE == 4
    return bayer4(pos);
    #endif
    #if LAYER_TWO_BAYER_SIZE == 8
    return bayer8(pos);
    #endif
    #if LAYER_TWO_BAYER_SIZE == 16
    return bayer16(pos);
    #endif
  #endif

  return 0.5; // fallback
}

float layerThreeDither(vec2 pos) {
 #if LAYER_THREE_DITHER == DITHER_WHITENOISE
  return texelFetch(noisetex, ivec2(mod(pos, vec2(NOISE_SIZE))), 0).r;
  #endif
  #if LAYER_THREE_DITHER == DITHER_BLUENOISE
  return texelFetch(colortex4, ivec2(mod(pos, vec2(NOISE_SIZE))), 0).r;
  #endif
  #if LAYER_THREE_DITHER == DITHER_BAYER
    #if LAYER_THREE_BAYER_SIZE == 2
    return bayer2(pos);
    #endif
    #if LAYER_THREE_BAYER_SIZE == 4
    return bayer4(pos);
    #endif
    #if LAYER_THREE_BAYER_SIZE == 8
    return bayer8(pos);
    #endif
    #if LAYER_THREE_BAYER_SIZE == 16
    return bayer16(pos);
    #endif
  #endif

  return 0.5; // fallback
}
// ========DITHER FUNCTIONS END========

// ===========LAYER HANDLING===========
// handle each render layer separately to be composited later

vec4 handleLayerOne(sampler2D colortex) {
  vec4 color;
  // sample at downscaled resolution
  vec2 tmp = ceil(gl_FragCoord.xy * LAYER_ONE_SCALE) / LAYER_ONE_SCALE;
  ivec2 dsFragCoord = ivec2(tmp.x, tmp.y);
  color = texelFetch(colortex, dsFragCoord, 0);
  color.rgb = srgbToLinear(color.rgb);

  #ifdef LAYER_ONE_MONOCHROME
  float value = luminance(color.rgb);
  float noisy = clamp(value + (layerOneDither(dsFragCoord * LAYER_ONE_SCALE) - 0.5) / (layerOneNumColors - 1), 0.0, 1.0);
  color.rgb = vec3(uniformQuantize(noisy, layerOneNumColors));
  #endif

  #ifndef LAYER_ONE_MONOCHROME
  vec3 noisy = clamp(color.rgb + (layerOneDither(dsFragCoord * LAYER_ONE_SCALE) - 0.5) / (layerOneNumColors - 1), 0.0, 1.0);
  color.rgb = uniformQuantize(noisy, vec3(layerOneNumColors));
  #endif

  color.rgb = linearToSrgb(color.rgb);
  return color;
}

vec4 handleLayerTwo(sampler2D colortex) {
  vec4 color;
  // sample at downscaled resolution
  vec2 tmp = ceil(gl_FragCoord.xy * LAYER_TWO_SCALE) / LAYER_TWO_SCALE;
  ivec2 dsFragCoord = ivec2(tmp.x, tmp.y);
  color = texelFetch(colortex, dsFragCoord, 0);
  color.rgb = srgbToLinear(color.rgb);

  #ifdef LAYER_TWO_MONOCHROME
  float value = luminance(color.rgb);
  float noisy = clamp(value + (layerTwoDither(dsFragCoord * LAYER_TWO_SCALE) - 0.5) / (layerTwoNumColors - 1), 0.0, 1.0);
  color.rgb = vec3(uniformQuantize(noisy, layerTwoNumColors));
  #endif

  #ifndef LAYER_TWO_MONOCHROME
  vec3 noisy = clamp(color.rgb + (layerTwoDither(dsFragCoord * LAYER_TWO_SCALE) - 0.5) / (layerTwoNumColors - 1), 0.0, 1.0);
  color.rgb = uniformQuantize(noisy, vec3(layerTwoNumColors));
  #endif

  color.rgb = linearToSrgb(color.rgb);
  return color;
}

vec4 handleLayerThree(sampler2D colortex) {
  vec4 color;
  // sample at downscaled resolution
  vec2 tmp = ceil(gl_FragCoord.xy * LAYER_THREE_SCALE) / LAYER_THREE_SCALE;
  ivec2 dsFragCoord = ivec2(tmp.x, tmp.y);
  color = texelFetch(colortex, dsFragCoord, 0);
  color.rgb = srgbToLinear(color.rgb);

  #ifdef LAYER_THREE_MONOCHROME
  float value = luminance(color.rgb);
  float noisy = clamp(value + (layerThreeDither(dsFragCoord * LAYER_THREE_SCALE) - 0.5) / (layerThreeNumColors - 1), 0.0, 1.0);
  color.rgb = vec3(uniformQuantize(noisy, layerThreeNumColors));
  #endif

  #ifndef LAYER_THREE_MONOCHROME
  vec3 noisy = clamp(color.rgb + (layerThreeDither(dsFragCoord * LAYER_THREE_SCALE) - 0.5) / (layerThreeNumColors - 1), 0.0, 1.0);
  color.rgb = uniformQuantize(noisy, vec3(layerThreeNumColors));
  #endif

  color.rgb = linearToSrgb(color.rgb);
  return color;
}
// =========LAYER HANDLING END=========

void main() {
  // process opaque and transparent layers
  vec4 colorOne   = handleLayerOne(colortex0);
  vec4 colorTwo   = handleLayerTwo(colortex0);
  vec4 colorThree = handleLayerThree(colortex0);
  vec4 transOne   = handleLayerOne(colortex10);
  vec4 transTwo   = handleLayerTwo(colortex10);
  vec4 transThree = handleLayerThree(colortex10);

  vec2 tmp = ceil(gl_FragCoord.xy * CUTOUT_SCALE) / CUTOUT_SCALE;
  ivec2 dsFragCoord = ivec2(tmp.x, tmp.y);
	vec4 cutouts = texelFetch(colortex2, dsFragCoord, 0);
  vec4 trans_cutouts = texelFetch(colortex3, dsFragCoord, 0);

  // composite cutouts and alpha blend transparent layers
  color = colorOne * cutouts.r + colorTwo * cutouts.g + colorThree * cutouts.b;
  vec4 trans = transOne * trans_cutouts.r + transTwo * trans_cutouts.g + transThree * trans_cutouts.b;
  color.rgb = color.rgb * (1 - trans.a) + trans.rgb;

  #ifdef DRAW_EDGES
  // edge detection and drawing
  vec2 grad;
  grad.x = grayConvolve3(sobelX, colortex1, gl_FragCoord.xy);
  grad.y = grayConvolve3(sobelY, colortex1, gl_FragCoord.xy);
  float edges = length(grad);
  // compute edge color
  // need to composite a completed grayscale image for this
  vec4 grayTrans = texture(colortex10, texcoord);
  float grayComplete = luminance(texture(colortex0, texcoord).rgb * (1 - grayTrans.a) + grayTrans.rgb);
  float edgeColorSwitch = step(edgeThreshold, grayComplete);
  vec4 edgeColor       = darkEdgeColor * edgeColorSwitch + lightEdgeColor * (1 - edgeColorSwitch);
  // draw the edges
  float edgeSwitch = step(0.01, edges);
  color = edgeColor * edgeSwitch + color * (1 - edgeSwitch);
  #endif

  #ifdef DISPLAY_OPAQUE_CUTOUTS
  color = cutouts;
  #endif
  #ifdef DISPLAY_TRANSPARENT_CUTOUTS
  color = trans_cutouts;
  #endif
}

#version 330 compatibility

#include /lib/settings.glsl
#include /lib/dither.glsl
#include /lib/util.glsl

uniform sampler2D colortex0; // all passes
uniform sampler2D colortex1; // terrain pass
uniform sampler2D colortex2; // everything else pass (for now)
uniform sampler2D colortex3; // transparent pass
uniform sampler2D colortex4; // depth values; (r,g) are for colortex 1 and 2 respectively
uniform sampler2D colortex5; // blue noise
uniform sampler2D noisetex;

uniform float viewHeight;
uniform float viewWidth;

/*
const int colortex4Format = RG32F;
const int colortex5Format = RGB8;
*/

in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// ==========DITHER FUNCTIONS==========
// dither functions for each layer

float layerOneDither(vec2 pos) {
 #if LAYER_ONE_DITHER == DITHER_WHITENOISE
  return texelFetch(noisetex, ivec2(mod(pos, vec2(NOISE_SIZE))), 0).r;
  #endif
  #if LAYER_ONE_DITHER == DITHER_BLUENOISE
  return texelFetch(colortex5, ivec2(mod(pos, vec2(NOISE_SIZE))), 0).r;
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
  return texelFetch(colortex5, ivec2(mod(pos, vec2(NOISE_SIZE))), 0).r;
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
  return texelFetch(colortex5, ivec2(mod(pos, vec2(NOISE_SIZE))), 0).r;
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

vec4 handleLayerOne() {
  vec4 color;
  // sample at downscaled resolution
  vec2 dsResolution = vec2(viewWidth, viewHeight) * LAYER_ONE_SCALE;
  vec2 dsTexcoord = uniformQuantize(texcoord, dsResolution + layerOneScaleOffset);
	color = texture(colortex1, dsTexcoord);
  color.rgb = pow(color.rgb, vec3(2.2)); // convert sRGB to linear

  #ifdef LAYER_ONE_MONOCHROME
  float value = dot(color.rgb, luminanceConvert);
  float noisy = clamp(value + (layerOneDither(dsTexcoord * dsResolution) - 0.5) / (layerOneNumColors - 1), 0.0, 1.0);
  color.rgb = vec3(uniformQuantize(noisy, layerOneNumColors));
  #endif

  #ifndef LAYER_ONE_MONOCHROME
  vec3 noisy = clamp(color.rgb + (layerOneDither(dsTexcoord * dsResolution) - 0.5) / (layerOneNumColors - 1), 0.0, 1.0);
  color.rgb = uniformQuantize(noisy, vec3(layerOneNumColors));
  #endif
 
  color.rgb = pow(color.rgb, vec3(1.0 / 2.2)); // convert to sRGB from linear
  return color;
}

vec4 handleLayerTwo() {
  vec4 color;
  // sample at downscaled resolution
  vec2 dsResolution = vec2(viewWidth, viewHeight) * LAYER_TWO_SCALE;
  vec2 dsTexcoord = uniformQuantize(texcoord, dsResolution + layerTwoScaleOffset);
	color = texture(colortex2, dsTexcoord);
  color.rgb = pow(color.rgb, vec3(2.2)); // convert sRGB to linear

  #ifdef LAYER_TWO_MONOCHROME
  float value = dot(color.rgb, luminanceConvert);
  float noisy = clamp(value + (layerTwoDither(dsTexcoord * dsResolution) - 0.5) / (layerTwoNumColors - 1), 0.0, 1.0);
  color.rgb = vec3(uniformQuantize(noisy, layerTwoNumColors));
  #endif

  #ifndef LAYER_TWO_MONOCHROME
  vec3 noisy = clamp(color.rgb + (layerTwoDither(dsTexcoord * dsResolution) - 0.5) / (layerTwoNumColors - 1), 0.0, 1.0);
  color.rgb = uniformQuantize(noisy, vec3(layerTwoNumColors));
  #endif
 
  color.rgb = pow(color.rgb, vec3(1.0 / 2.2)); // convert to sRGB from linear
  return color;
}

vec4 handleLayerThree() {
  vec4 color;
  // sample at downscaled resolution
  vec2 dsResolution = vec2(viewWidth, viewHeight) * LAYER_THREE_SCALE;
  vec2 dsTexcoord = uniformQuantize(texcoord, dsResolution + layerThreeScaleOffset);
	color = texture(colortex3, dsTexcoord);
  color.rgb = pow(color.rgb, vec3(2.2)); // convert sRGB to linear

  #ifdef LAYER_THREE_MONOCHROME
  float value = dot(color.rgb, luminanceConvert);
  float noisy = clamp(value + (layerThreeDither(dsTexcoord * dsResolution) - 0.5) / (layerThreeNumColors - 1), 0.0, 1.0);
  color.rgb = vec3(uniformQuantize(noisy, layerThreeNumColors));
  #endif

  #ifndef LAYER_THREE_MONOCHROME
  vec3 noisy = clamp(color.rgb + (layerThreeDither(dsTexcoord * dsResolution) - 0.5) / (layerThreeNumColors - 1), 0.0, 1.0);
  color.rgb = uniformQuantize(noisy, vec3(layerThreeNumColors));
  #endif
 
  color.rgb = pow(color.rgb, vec3(1.0 / 2.2)); // convert to sRGB from linear
  return color;
}
// =========LAYER HANDLING END=========

void main() {
  // compositing processed render layers
  vec4 colorOne = handleLayerOne();
  vec4 colorTwo = handleLayerTwo();
  vec4 trans    = handleLayerThree();
  vec4 depth = texture(colortex4, texcoord);

  // colorOne -= texture(colortex1, texcoord);
  // colorTwo -= texture(colortex2, texcoord);
  // trans    -= texture(colortex3, texcoord);

  float depthSwitch = float(depth.r > depth.g);
  color = colorOne * depthSwitch + colorTwo * (1 - depthSwitch);
  color.rgb = color.rgb * (1 - trans.a) + trans.rgb;
}

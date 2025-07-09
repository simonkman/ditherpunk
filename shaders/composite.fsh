#version 330 compatibility

#include /lib/settings.glsl
#include /lib/dither.glsl
#include /lib/util.glsl

uniform sampler2D colortex0; // all passes
uniform sampler2D colortex1; // terrain pass
uniform sampler2D colortex2; // ? pass
uniform sampler2D colortex4; // blue noise
uniform sampler2D noisetex;

uniform float viewHeight;
uniform float viewWidth;

/*
const int colortex0Format = RGB16;
const int colortex4Format = RGB8;
*/

in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

float dither(vec2 pos) {
 #if DITHER == DITHER_WHITENOISE
  return texelFetch(noisetex, ivec2(mod(pos, vec2(NOISE_SIZE))), 0).r;
  #endif
  #if DITHER == DITHER_BLUENOISE
  // vec2 idk = clamp(pos, vec2(0), vec2(viewWidth - 1, viewHeight - 1));
  return texelFetch(colortex4, ivec2(mod(pos, vec2(NOISE_SIZE))), 0).r;
  #endif
  #if DITHER == DITHER_BAYER
    #if BAYER_SIZE == 2
    return bayer2(pos);
    #endif
    #if BAYER_SIZE == 4
    return bayer4(pos);
    #endif
    #if BAYER_SIZE == 8
    return bayer8(pos);
    #endif
    #if BAYER_SIZE == 16
    return bayer16(pos);
    #endif
  #endif

  return 0.5; // fallback
}

void main() {
  // sample at downscaled resolution
  vec2 dsResolution = vec2(viewWidth, viewHeight) * SCALE;
  // TODO rewrite downscaling to be more accurate
  vec2 dsTexcoord = uniformQuantize(texcoord, dsResolution + scaleOffset);
	color = texture(colortex0, dsTexcoord);
  color.rgb = pow(color.rgb, vec3(2.2)); // convert sRGB to linear

  #ifdef MONOCHROME
  float value = dot(color.rgb, luminanceConvert);
  float noisy = clamp(value + (dither(dsTexcoord * dsResolution) - 0.5) / (numColors - 1), 0.0, 1.0);
  color.rgb = vec3(uniformQuantize(noisy, numColors));
  #endif

  #ifndef MONOCHROME
  vec3 noisy = clamp(color.rgb + (dither(dsTexcoord * dsResolution) - 0.5) / (numColors - 1), 0.0, 1.0);
  color.rgb = uniformQuantize(noisy, vec3(numColors));
  #endif
  
  // color.rgb = pow(texture(colortex0, dsTexcoord).rgb, vec3(2.2));
  // color.rgb = vec3(dither(texcoord * vec2(viewWidth, viewHeight)));
  // color.rgb = vec3(dither(dsTexcoord * dsResolution));
  // color.rgb = pow(texture(colortex1, texcoord).rgb, vec3(2.2));
}

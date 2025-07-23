#ifndef LIB_CONVOLUTION_GLSL
#define LIB_CONVOLUTION_GLSL

#include "util.glsl"

// Sobel operators (kernels) for x and y
// remember, these are stored in column major format, so it will look flipped
const mat3 sobelX = mat3(-1, -2, -1,
                          0,  0,  0,
                          1,  2,  1);
const mat3 sobelY = mat3(-1,  0,  1,
                         -2,  0,  2,
                         -1,  0,  1);

// Compute the convolution at texcoord on the grayscale (Luminance) image.
// src should already be grayscale, computations will be performed using its r component
// fragcoord should be from gl_FragCoord, with pixels being on integers instead of +0.5, +0.5
float grayConvolve3(mat3 kern, sampler2D src, vec2 fragcoord) {
  // things to remember with indexing:
  // src is indexed by (+x, +y), with origin in bottom left of screen
  // kern is indexed by [col][row]
  // we need to use the transpose of the matrix in convolution

  ivec2 coord = ivec2(fragcoord.x, fragcoord.y);
  ivec2 dim   = textureSize(src, 0);
  float sum = 0.0;
  for (int x = -1; x <= 1; x++) {
    for (int y = -1; y <= 1; y++) {
      // sample with edges extended so borders aren't drawn around the edge of screen with sobel
      float tex = texelFetch(src, clamp(coord + ivec2(x, y), ivec2(0, 0), dim - 1), 0).r;
      sum += kern[1-y][x+1] * tex;
    }
  }

  return sum;
}
#endif

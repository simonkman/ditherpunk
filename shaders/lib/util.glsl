#ifndef LIB_UTIL_GLSL
#define LIB_UTIL_GLSL
// quantize x in range [0.0, 1.0] to uniformally distributed steps
float uniformQuantize(float x, float steps) {
  return floor(x * (steps - 1) + 0.5) / (steps - 1);
}

// quantize x in range [0.0, 1.0] to uniformally distributed steps
vec2 uniformQuantize(vec2 x, vec2 steps) {
  return floor(x * (steps - 1) + 0.5) / (steps - 1);
}

// quantize x in range [0.0, 1.0] to uniformally distributed steps
vec3 uniformQuantize(vec3 x, vec3 steps) {
  return floor(x * (steps - 1) + 0.5) / (steps - 1);
}

// get luminance for conversion to grayscale
float luminance(vec3 color) {
  return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

// convert colorspaces
vec3 srgbToLinear(vec3 color) {
  vec3 cond = step(0.04045, color);
  return cond * pow(((color + 0.055) / 1.055), vec3(2.4)) +
         (1 - cond) * (color / 12.92);
}

// convert colorspaces
vec3 linearToSrgb(vec3 color) {
  vec3 cond = step(0.0031308, vec3(color));
  return cond * (1.055 * pow(color, vec3(1.0 / 2.4)) - 0.055) +
         (1 - cond) * (12.92 * color);
}

// convert colorspaces
float srgbToLinear(float color) {
  float cond = step(0.04045, color);
  return cond * pow(((color + 0.055) / 1.055), 2.4) +
         (1 - cond) * (color / 12.92);
}

// convert colorspaces
float linearToSrgb(float color) {
  float cond = step(0.0031308, color);
  return cond * (1.055 * pow(color, 1.0 / 2.4) - 0.055) +
         (1 - cond) * (12.92 * color);
}

// convert colorspaces
// math given by Bjorn Ottoson's oklab white paper
vec3 linearToOklab(vec3 c) {
  const mat3 m1 = mat3( 0.4122214708,  0.5363325363, 0.0514459929,   // col 1
                        0.2119034982,  0.6806995451, 0.1073969566,   // col 2
                        0.0883024619,  0.2817188376, 0.6299787005);  // col 3

  const mat3 m2 = mat3( 0.2104542553,  0.7936177850, -0.0040720468,  // col 1
                        1.9779984951, -2.4285922050,  0.4505937099,  // col 2
                        0.0259040371,  0.7827717662, -0.8086757660); // col 3

  return pow(c * m1, vec3(1.0 / 3.0)) * m2;
}

// convert colorspaces
// math given by Bjorn Ottoson's oklab white paper
vec3 oklabToLinear(vec3 c) {
  const mat3 m1 = mat3( 1           ,  0.3963377774,  0.2158037573,  // col 1
                        1           , -0.1055613458, -0.0638541728,  // col 2
                        1           , -0.0894841775, -1.2914855480); // col 3

  const mat3 m2 = mat3( 4.0767416621, -3.3077115913,  0.2309699292,  // col 1
                       -1.2684380046,  2.6097574011, -0.3413193965,  // col 2
                       -0.0041960863, -0.7034186147,  1.7076147010); // col 3

  return pow(c * m1, vec3(3.0)) * m2;
}

// linearizes depth z.
// Most places say opengl has depth in range [-1,1], but
// minecraft seems to have it in range [0,1]?
float linearizeDepth(float z, float near, float far) {
  return 2.0 * near / (near + far - z * (far - near));
}
#endif

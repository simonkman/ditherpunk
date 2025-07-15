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

// linearizes depth z.
// Most places say opengl has depth in range [-1,1], but
// minecraft seems to have it in range [0,1]?
float linearizeDepth(float z, float near, float far) {
  return 2.0 * near / (near + far - z * (far - near));
}
#endif

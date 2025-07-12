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
  return pow(color, vec3(2.2));
}

// convert colorspaces
vec3 linearToSrgb(vec3 color) {
  return pow(color, vec3(1.0 / 2.2));
}

// convert colorspaces
float srgbToLinear(float color) {
  return pow(color, 2.2);
}

// convert colorspaces
float linearToSrgb(float color) {
  return pow(color, 1.0 / 2.2);
}
#endif

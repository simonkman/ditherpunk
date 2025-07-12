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

// value to dot product linear color with to convert to grayscale
const vec3 luminanceConvert = vec3(0.2126, 0.7152, 0.0722);
#endif

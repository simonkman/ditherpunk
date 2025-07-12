#ifndef LIB_EDGE_LAYERS_GLSL
#define LIB_EDGE_LAYERS_GLSL
const float numLayers = 16;

const vec4 armorGlint  = vec4( 0 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 basic       = vec4( 1 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 beaconbeam  = vec4( 2 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 block       = vec4( 3 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 clouds      = vec4( 4 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 entities    = vec4( 5 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 hand        = vec4( 6 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 handWater   = vec4( 7 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 skybasic    = vec4( 8 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 skytextured = vec4( 9 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 spidereyes  = vec4(10 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 terrain     = vec4(11 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 textured    = vec4(12 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 texturedLit = vec4(13 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 water       = vec4(14 * vec3(1, 1, 1) / (numLayers - 1), 1);
const vec4 weather     = vec4(15 * vec3(1, 1, 1) / (numLayers - 1), 1);
#endif

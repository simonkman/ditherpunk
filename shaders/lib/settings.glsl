#ifndef LIB_SETTINGS_GLSL
#define LIB_SETTINGS_GLSL
// preprocesser directives for user options

// Dither types
#define DITHER_NONE       0
#define DITHER_WHITENOISE 1
#define DITHER_BLUENOISE  2
#define DITHER_BAYER      3

#define NOISE_SIZE 256

#define CUTOUT_SCALE 1.0 // [0.0625 0.125 0.25 0.5 1.0] Cutout compositing resolution downscale

// =============================
// ==========LAYER_ONE==========
// =============================
#define LAYER_ONE_MONOCHROME // Enable grayscale

#define LAYER_ONE_SCALE 1.0 // [0.0625 0.125 0.25 0.5 1.0] Resolution downscale
#define LAYER_ONE_BIT_DEPTH 1 // [1 2 3 4 5 6 7 8 16] Bit depth per color channel

#define LAYER_ONE_DITHER 3 // [0 1 2 3]
#define LAYER_ONE_BAYER_SIZE 8 // [2 4 8 16]

// number of colors per channel
const float layerOneNumColors = 2 << (LAYER_ONE_BIT_DEPTH - 1);

// =============================
// ==========LAYER_TWO==========
// =============================
#define LAYER_TWO_MONOCHROME // Enable grayscale

#define LAYER_TWO_SCALE 1.0 // [0.0625 0.125 0.25 0.5 1.0] Resolution downscale
#define LAYER_TWO_BIT_DEPTH 1 // [1 2 3 4 5 6 7 8 16] Bit depth per color channel

#define LAYER_TWO_DITHER 3 // [0 1 2 3]
#define LAYER_TWO_BAYER_SIZE 8 // [2 4 8 16]

// CONSTANTS DERIVED FROM SETTINGS

// number of colors per channel
const float layerTwoNumColors = 2 << (LAYER_TWO_BIT_DEPTH - 1);

// =============================
// =========LAYER_THREE=========
// =============================
#define LAYER_THREE_MONOCHROME // Enable grayscale

#define LAYER_THREE_SCALE 1.0 // [0.0625 0.125 0.25 0.5 1.0] Resolution downscale
#define LAYER_THREE_BIT_DEPTH 1 // [1 2 3 4 5 6 7 8 16] Bit depth per color channel

#define LAYER_THREE_DITHER 3 // [0 1 2 3]
#define LAYER_THREE_BAYER_SIZE 8 // [2 4 8 16]

// CONSTANTS DERIVED FROM SETTINGS

// number of colors per channel
const float layerThreeNumColors = 2 << (LAYER_THREE_BIT_DEPTH - 1);

// =============================
// ====GBUFFERS_LAYER_SELECT====
// =============================
// chooses which layer each gbuffer will render to
// (by layer we really mean which color in the cutout image)
#define GBUFFERS_ARMOR_GLINT_LAYER  1 // [1 2 3]
#define GBUFFERS_BASIC_LAYER        1 // [1 2 3]
#define GBUFFERS_BEACONBEAM_LAYER   1 // [1 2 3]
#define GBUFFERS_BLOCK_LAYER        1 // [1 2 3]
#define GBUFFERS_CLOUDS_LAYER       1 // [1 2 3]
#define GBUFFERS_ENTITIES_LAYER     1 // [1 2 3]
#define GBUFFERS_HAND_LAYER         1 // [1 2 3]
#define GBUFFERS_HAND_WATER_LAYER   1 // [1 2 3]
#define GBUFFERS_SKYBASIC_LAYER     1 // [1 2 3]
#define GBUFFERS_SKYTEXTURED_LAYER  1 // [1 2 3]
#define GBUFFERS_SPIDEREYES_LAYER   1 // [1 2 3]
#define GBUFFERS_TERRAIN_LAYER      1 // [1 2 3]
#define GBUFFERS_TEXTURED_LAYER     1 // [1 2 3]
#define GBUFFERS_TEXTURED_LIT_LAYER 1 // [1 2 3]
#define GBUFFERS_WATER_LAYER        1 // [1 2 3]
#define GBUFFERS_WEATHER_LAYER      1 // [1 2 3]

#endif

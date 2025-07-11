// preprocesser directives for user options

// Dither types
#define DITHER_NONE       0
#define DITHER_WHITENOISE 1
#define DITHER_BLUENOISE  2
#define DITHER_BAYER      3

// =============================
// ==========LAYER_ONE==========
// =============================
#define LAYER_ONE_MONOCHROME // Enable grayscale

#define LAYER_ONE_SCALE 1.0 // [0.0625 0.125 0.25 0.5 1.0] Resolution downscale
#define LAYER_ONE_BIT_DEPTH 1 // [1 2 3 4 5 6 7 8 16] Bit depth per color channel
#define NOISE_SIZE 256

#define LAYER_ONE_DITHER 3 // [0 1 2 3]
#define LAYER_ONE_BAYER_SIZE 8 // [2 4 8 16]

// CONSTANTS DERIVED FROM SETTINGS

// I have no idea why you need this, but without things scale improperly
#if LAYER_ONE_SCALE == 1.0
const float layerOneScaleOffset = 0;
#endif
#if LAYER_ONE_SCALE != 1.0
const float layerOneScaleOffset = 1;
#endif

// number of colors per channel
const float layerOneNumColors = 2 << (LAYER_ONE_BIT_DEPTH - 1);

// =============================
// ==========LAYER_TWO==========
// =============================
#define LAYER_TWO_MONOCHROME // Enable grayscale

#define LAYER_TWO_SCALE 1.0 // [0.0625 0.125 0.25 0.5 1.0] Resolution downscale
#define LAYER_TWO_BIT_DEPTH 1 // [1 2 3 4 5 6 7 8 16] Bit depth per color channel
#define NOISE_SIZE 256

#define LAYER_TWO_DITHER 3 // [0 1 2 3]
#define LAYER_TWO_BAYER_SIZE 8 // [2 4 8 16]

// CONSTANTS DERIVED FROM SETTINGS

// I have no idea why you need this, but without things scale improperly
#if LAYER_TWO_SCALE == 1.0
const float layerTwoScaleOffset = 0;
#endif
#if LAYER_TWO_SCALE != 1.0
const float layerTwoScaleOffset = 1;
#endif

// number of colors per channel
const float layerTwoNumColors = 2 << (LAYER_TWO_BIT_DEPTH - 1);

// =============================
// =========LAYER_THREE=========
// =============================
#define LAYER_THREE_MONOCHROME // Enable grayscale

#define LAYER_THREE_SCALE 1.0 // [0.0625 0.125 0.25 0.5 1.0] Resolution downscale
#define LAYER_THREE_BIT_DEPTH 1 // [1 2 3 4 5 6 7 8 16] Bit depth per color channel
#define NOISE_SIZE 256

#define LAYER_THREE_DITHER 3 // [0 1 2 3]
#define LAYER_THREE_BAYER_SIZE 8 // [2 4 8 16]

// CONSTANTS DERIVED FROM SETTINGS

// I have no idea why you need this, but without things scale improperly
#if LAYER_THREE_SCALE == 1.0
const float layerThreeScaleOffset = 0;
#endif
#if LAYER_THREE_SCALE != 1.0
const float layerThreeScaleOffset = 1;
#endif

// number of colors per channel
const float layerThreeNumColors = 2 << (LAYER_THREE_BIT_DEPTH - 1);

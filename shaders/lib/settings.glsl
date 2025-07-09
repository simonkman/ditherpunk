// preprocesser directives for user options

#define MONOCHROME // Enable grayscale

#define SCALE 1.0 // [0.0625 0.125 0.25 0.5 1.0] Resolution downscale
#define BIT_DEPTH 1 // [1 2 3 4 5 6 7 8 16] Bit depth per color channel
#define NOISE_SIZE 256

#define DITHER 3 // [0 1 2 3]
#define DITHER_NONE       0
#define DITHER_WHITENOISE 1
#define DITHER_BLUENOISE  2
#define DITHER_BAYER      3

#define BAYER_SIZE 8 // [2 4 8 16]

/*
* CONSTANTS DERIVED FROM SETTINGS
*/
// I have no idea why you need this, but without things scale improperly
#if SCALE == 1.0
const float scaleOffset = 0;
#endif
#if SCALE != 1.0
const float scaleOffset = 1;
#endif

// number of colors per channel
const float numColors = 2 << (BIT_DEPTH - 1);

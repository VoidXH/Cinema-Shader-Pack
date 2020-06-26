/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Try to get the SDR part of HDR content
*/

// Configuration ---------------------------------------------------------------
const static float peakLuminance = 200.0; // Peak playback screen luminance in nits
const static float maxCLL = 1000.0; // Maximum content light level in nits
const static float minMDL = 0.0; // Minimum mastering display luminance in nits
const static float maxMDL = 1000.0; // Maximum mastering display luminance in nits
const static float kneeLuminance = 50.0; // Largest uncompressed luminance in nits
// -----------------------------------------------------------------------------

// Precalculated values
const static float linGain = maxCLL / peakLuminance * (maxMDL - minMDL) / maxMDL;
const static float blackPoint = minMDL / maxMDL;
const static float knee = kneeLuminance / peakLuminance;

sampler s0;

inline float luma(float3 pixel) {
  return 0.2126 * pixel.r + 0.7152 * pixel.g + 0.0722 * pixel.b;
}

inline float3 sLog2srgb(float3 sLog) {
  return (pow(10.0, ((((sLog * 256.0 - 16.0) / 219.0) - 0.616596 - 0.03) / 0.432699)) - 0.037584) * 0.9;
}

inline float3 srgb2lin(float3 srgb) {
  return srgb <= 0.04045 ? srgb / 12.92 : pow((srgb + 0.055) / 1.055, 2.4);
}

inline float3 lin2srgb(float3 lin) {
  return lin <= 0.0031308 ? lin * 12.92 : (1.055 * pow(lin, 0.416667) - 0.055);
}

inline float3 bt2020to709(float3 bt2020) { // in linear space
  return float3(
    bt2020.r * 1.6605 + bt2020.g * -0.5876 + bt2020.b * -0.0728,
    bt2020.r * -0.1246 + bt2020.g * 1.1329 + bt2020.b * -0.0083,
    bt2020.r * -0.0182 + bt2020.g * -0.1006 + bt2020.b * 1.1187);
}

inline float3 compress(float3 pixel) { // in linear space
  float3 dry = pixel * linGain + blackPoint;
  float lm = luma(dry);
  float t = pow(saturate((lm - knee) / (linGain - knee)), 0.5);
  return dry * (1 - t) + pixel * t;
}

float4 main(float2 tex : TEXCOORD0) : COLOR {
  float3 pxval = tex2D(s0, tex).rgb;
  float3 lin = bt2020to709(saturate(srgb2lin(sLog2srgb(pxval))));
  float3 final = lin2srgb(compress(lin));
  return final.rgbb;
}
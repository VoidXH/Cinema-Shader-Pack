/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Try to get the SDR part of S-Log HDR content
*/

// Configuration ---------------------------------------------------------------
const static float peakLuminance = 100.0; // Peak playback screen luminance in nits
const static float kneeLuminance = 75.0; // Compression knee in luminance
const static float compression = 1.0; // Compression ratio
const static float maxCLL = 10000.0; // Maximum content light level in nits
const static float minMDL = 0.0; // Minimum mastering display luminance in nits
const static float maxMDL = 10000.0; // Maximum mastering display luminance in nits
// -----------------------------------------------------------------------------

// Precalculated values
const static float linGain = maxCLL / peakLuminance * (maxMDL - minMDL) / maxMDL;
const static float blackPoint = minMDL / maxMDL;
const static float knee = kneeLuminance / maxCLL;

sampler s0;

inline float peakGain(float3 pixel) {
  return max(pixel.r, max(pixel.g, pixel.b));
}

inline float3 sLog2srgb(float3 sLog) {
  return (pow(10.0, ((((sLog * 256.0 - 16.0) / 219.0) - 0.616596 - 0.03) / 0.432699)) - 0.037584) / 10.8857;
}

inline float3 srgb2lin(float3 srgb) {
  return srgb <= 0.04045 ? srgb / 12.92 : pow((srgb + 0.055) / 1.055, 2.4);
}

inline float3 lin2srgb(float3 lin) {
  return lin <= 0.0031308 ? lin * 12.92 : 1.055 * pow(lin, 0.416667) - 0.055;
}

inline float3 bt2020to709(float3 bt2020) { // in linear space
  return float3(
    bt2020.r * 1.6605 + bt2020.g * -0.5876 + bt2020.b * -0.0728,
    bt2020.r * -0.1246 + bt2020.g * 1.1329 + bt2020.b * -0.0083,
    bt2020.r * -0.0182 + bt2020.g * -0.1006 + bt2020.b * 1.1187);
}

inline float3 compress(float3 pixel) { // in linear space
  float kneeMax = knee * linGain + blackPoint;
  float strength = saturate((peakGain(pixel) - kneeMax) / ((linGain + blackPoint) - kneeMax));
  return pixel / ((compression - 1) * strength + 1);
}

float4 main(float2 tex : TEXCOORD0) : COLOR {
  float3 pxval = tex2D(s0, tex).rgb;
  float3 lin = bt2020to709(srgb2lin(sLog2srgb(pxval))) * linGain + blackPoint;
  float3 final = lin2srgb(compress(lin));
  return final.rgbb;
}
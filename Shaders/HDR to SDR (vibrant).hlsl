/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: HDR to SDR with a different, sometimes better looking compressor
*/

// Configuration ---------------------------------------------------------------
const static float peakLuminance = 250.0; // Peak playback screen luminance in nits
const static float maxCLL = 10000.0; // Maximum content light level in nits
const static float minMDL = 0.0; // Minimum mastering display luminance in nits
const static float maxMDL = 1000.0; // Maximum mastering display luminance in nits
const static float kneeLuminance = 50.0; // Largest uncompressed luminance in nits
// -----------------------------------------------------------------------------

// Precalculated values
const static float linGain = maxCLL / peakLuminance * (maxMDL - minMDL) / maxMDL;
const static float blackPoint = minMDL / maxMDL;
const static float knee = kneeLuminance / peakLuminance;

// PQ constants
const static float m1inv = 16384 / 2610.0;
const static float m2inv = 32 / 2523.0;
const static float c1 = 3424 / 4096.0;
const static float c2 = 2413 / 128.0;
const static float c3 = 2392 / 128.0;

sampler s0;

inline float minGain(float3 pixel) {
  return min(pixel.r, min(pixel.g, pixel.b));
}

inline float midGain(float3 pixel) {
  return pixel.r < pixel.g ?
    (pixel.r < pixel.b ?
      min(pixel.g, pixel.b) : // min = r
      min(pixel.r, pixel.g)) : // min = b
    (pixel.g < pixel.b ?
      min(pixel.r, pixel.b) : // min = g
      min(pixel.r, pixel.g)); // min = b
}

inline float maxGain(float3 pixel) {
  return max(pixel.r, max(pixel.g, pixel.b));
}

inline float luma(float3 pixel) {
  return 0.2126 * pixel.r + 0.7152 * pixel.g + 0.0722 * pixel.b;
}

inline float3 compress(float3 pixel) { // in linear space
  float3 dry = pixel * linGain + blackPoint;
  float lm = luma(dry);
  float t = pow(saturate((lm - knee) / (linGain - knee)), 0.5);
  return dry * (1 - t) + pixel * t;
}

inline float3 fixClip(float3 pixel) {
  // keep the (mid - min) / (max - min) ratio
  float preMin = minGain(pixel);
  float preMid = midGain(pixel);
  float preMax = maxGain(pixel);
  float3 clip = saturate(pixel);
  float postMin = minGain(clip);
  float postMid = midGain(clip);
  float postMax = maxGain(clip);
  float ratio = (preMid - preMin) / (preMax - preMin);
  float newMid = ratio * (postMax - postMin) + postMin;
  return float3(clip.r != postMid ? clip.r : newMid,
                clip.g != postMid ? clip.g : newMid,
                clip.b != postMid ? clip.b : newMid);
}

inline float3 pq2lin(float3 pq) { // Returns luminance in nits
  float3 p = pow(pq, m2inv);
  float3 d = max(p - c1, 0) / (c2 - c3 * p);
  return pow(d, m1inv);
}

inline float3 srgb2lin(float3 srgb) {
  return srgb <= 0.04045 ? srgb / 12.92 : pow((srgb + 0.055) / 1.055, 2.4);
}

inline float3 lin2srgb(float3 lin) {
  return lin <= 0.0031308 ? lin * 12.92 : 1.055 * pow(lin, 0.416667) - 0.055;
}

inline float3 bt2020to709(float3 bt2020) { // in linear space
  return float3(
    bt2020.r *  1.6605 + bt2020.g * -0.5876 + bt2020.b * -0.0728,
    bt2020.r * -0.1246 + bt2020.g *  1.1329 + bt2020.b * -0.0083,
    bt2020.r * -0.0182 + bt2020.g * -0.1006 + bt2020.b * 1.1187);
}

float4 main(float2 tex : TEXCOORD0) : COLOR {
  float3 pxval = tex2D(s0, tex).rgb;
  float3 lin = bt2020to709(pq2lin(pxval));
  float3 final = lin2srgb(compress(lin));
  return fixClip(final).rgbb;
}
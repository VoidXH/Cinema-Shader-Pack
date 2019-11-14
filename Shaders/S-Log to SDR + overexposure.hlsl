/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Try to get the SDR part of S-Log HDR content with overexposure as SBS 3D
*/

// Configuration ---------------------------------------------------------------
const static float peakBrightness = 3000.0; // Peak playback screen brightness in nits
// -----------------------------------------------------------------------------

// Precalculated values
const static float brightnessCorrection = 10000.0 / peakBrightness;

sampler s0;

float4 main(float2 tex : TEXCOORD0) : COLOR {
  float splitval = tex.x < 0.5 ? 0 : 1;
  tex.x = tex.x < 0.5 ? tex.x * 2.0 : (tex.x - 0.5) * 2.0;
  float4 pxval = (tex2D(s0, tex)).rgbb;
  float4 sdr = (pow(10.0, ((((pxval * 256.0 - 16.0) / 219.0) - 0.616596 - 0.03) / 0.432699)) - 0.037584) * brightnessCorrection;
  float4 highlight = sdr - 1.0;
  return splitval < 0.5 ? sdr : highlight;
}
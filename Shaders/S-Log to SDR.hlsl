/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Try to get the SDR part of S-Log HDR content
*/

// Configuration ---------------------------------------------------------------
const static float peakBrightness = 3000.0; // Peak playback screen brightness in nits
// -----------------------------------------------------------------------------

// Precalculated values
const static float brightnessCorrection = 10000.0 / peakBrightness;

sampler s0;

float4 main(float2 tex : TEXCOORD0) : COLOR {
  float4 pxval = (tex2D(s0, tex)).rgbb;
  return (pow(10.0, ((((pxval * 256.0 - 16.0) / 219.0) - 0.616596 - 0.03) / 0.432699)) - 0.037584) * brightnessCorrection;
}
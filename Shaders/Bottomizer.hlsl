/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Move wide content to the bottom of the frame
*/

// Configuration ---------------------------------------------------------------
const static float v = 5 / 256.0; // Target darkness (peak noise level)
// -----------------------------------------------------------------------------

sampler s0;
float4 p0 : register(c0);

#define width (p0[0])
#define height (p0[1])

float cp(float w, float h) { // Check a point if it's below target darnkess
  float3 p = tex2D(s0, float2(w, h)).rgb;
  return p.r < v && p.g < v && p.b < v;
}

float checkLayer(float t) {
  return cp(0, t) && cp(0.2, t) && cp(0.4, t) && cp(0.6, t) && cp(0.8, t) && cp(1, t);
}

float ratioTest(float container, float ratio) {
  float h = 0.05 + container / ratio;
  return ratio > container ? checkLayer((1 + h) * 0.5) && checkLayer((1 - h) * 0.5) : 0;
}

float2 ratioOffset(float container, float ratio) {
  return float2(0, (container / ratio + 1) * 0.5 - 1);
}

float4 main(float2 tex : TEXCOORD0) : COLOR {
  float container = width / height;
  tex +=
    ratioTest(container, 2.34) ? ratioOffset(container, 2.34) :
    ratioTest(container, 2.2) ? ratioOffset(container, 2.2) :
    ratioTest(container, 2) ? ratioOffset(container, 2) :
    ratioTest(container, 1.85) ? ratioOffset(container, 1.85) :
    float2(0, 0);
  return tex2D(s0, tex).rgbb;
}
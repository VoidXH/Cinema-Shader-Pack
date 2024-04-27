/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Fill black bars by cylindrically warping the image
*/

sampler s0;
float4 p0 : register(c0);

#define width (p0[0])
#define height (p0[1])

const static float v = 5 / 256.0; // Target darkness (peak noise level)

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

float2 warp(float2 tex, float container, float content, float factor) {
  float a = factor * content / container;
  return float2(tex.x, atan(a * (tex.y - 0.5)) / a + 0.5);
}

inline float4 getTex(float2 tex) {
  return tex.x >= 0 && tex.x <= 1 && tex.y >=0 && tex.y <= 1 ? tex2D(s0, tex) : 0;
}

float4 main(float2 tex : TEXCOORD0) : COLOR {
  float container = width / height;
  if (ratioTest(container, 2.2)) {
    tex = warp(tex, container, 2.2, 1.8);
  } else if (ratioTest(container, 2)) {
    tex = warp(tex, container, 2, 1);
  }
  
  // Anti-aliased output with standard 8x MSAA pattern
  float2 px = float2(1.0 / width, 1.0 / height); // pixel size
  float4 aa1 = getTex(tex + float2(px.x * 0.1, px.y * -0.3));
  float4 aa2 = getTex(tex + float2(px.x * -0.1, px.y * 0.3));
  float4 aa3 = getTex(tex + float2(px.x * 0.5, px.y * 0.1));
  float4 aa4 = getTex(tex + float2(px.x * -0.3, px.y * -0.5));
  float4 aa5 = getTex(tex + float2(px.x * -0.5, px.y * 0.5));
  float4 aa6 = getTex(tex + float2(px.x * -0.7, px.y * -0.1));
  float4 aa7 = getTex(tex + float2(px.x * 0.3, px.y * 0.7));
  float4 aa8 = getTex(tex + float2(px.x * 0.7, px.y * -0.7));
  return (aa1 + aa2 + aa3 + aa4 + aa5 + aa6 + aa7 + aa8) * 0.125;
}

/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Prepare side-by-side 3D content for anaglyph glasses
*/

// Configuration ---------------------------------------------------------------
const static float addDubois = 0; // Apply Dubois correction for poor red usage (1 = on, 0 = off)
// -----------------------------------------------------------------------------

sampler s0;
float4 p0 : register(c0);

#define width (p0[0])
#define height (p0[1])

inline float3 dubois(float4 l, float4 r) { // By kazuya2k8 at https://forum.doom9.org/showthread.php?t=170475
	float red   = l.r* 0.456 + l.g* 0.500 + l.b* 0.176  +  r.r*-0.043 + r.g*-0.088 + r.b*-0.002;
	float green = l.r*-0.040 + l.g*-0.038 + l.b*-0.016  +  r.r* 0.378 + r.g* 0.734 + r.b*-0.018;
	float blue  = l.r*-0.015 + l.g*-0.021 + l.b*-0.005  +  r.r*-0.072 + r.g*-0.113 + r.b* 1.226;
	return float3(red, green, blue);
}

float4 main(float2 tex : TEXCOORD0) : COLOR {
	tex.x *= .5;
  float2 texr = tex;
  texr.x += .5;
  float pixelSize = 1. / width;
	float3 leftPixel = addDubois < .5 ? float3(tex2D(s0, tex).r, tex2D(s0, texr).gb) : dubois(tex2D(s0, tex), tex2D(s0, texr));
  tex.x += pixelSize;
  texr.x += pixelSize;
  float3 rightPixel = addDubois < .5 ? float3(tex2D(s0, tex).r, tex2D(s0, texr).gb) : dubois(tex2D(s0, tex), tex2D(s0, texr));
  return (tex.x * width) % 1 < .5 ? leftPixel.rgbb : (leftPixel + rightPixel).rgbb * .5;
}
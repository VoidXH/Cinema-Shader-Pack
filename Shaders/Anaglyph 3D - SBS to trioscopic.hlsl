/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Prepare side-by-side 3D content for trioscopic glasses
*/

sampler s0;
float4 p0 : register(c0);

#define width (p0[0])
#define height (p0[1])

float4 main(float2 tex : TEXCOORD0) : COLOR {
	tex.x *= .5;
  float2 texr = tex;
  texr.x += .5;
  float pixelSize = 1. / width;
	float3 leftPixel = float3(tex2D(s0, texr).r, tex2D(s0, tex).g, tex2D(s0, texr).b);
  tex.x += pixelSize;
  texr.x += pixelSize;
  float3 rightPixel = float3(tex2D(s0, texr).r, tex2D(s0, tex).g, tex2D(s0, texr).b);
  return (tex.x * width) % 1 < .5 ? leftPixel.rgbb : (leftPixel + rightPixel).rgbb * .5;
}
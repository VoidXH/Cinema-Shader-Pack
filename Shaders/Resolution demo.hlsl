/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Shows half resolution 4:2:0, 4:4:4, full resolution 4:2:0, and 4:4:4 in order
*/

sampler s0;
float4 p0 : register(c0);

#define width (p0[0])
#define height (p0[1])

float4 halfColor(float4 color, float2 tex, float downscale) {
  float2 downscaled = float2(downscale / width, downscale / height);
  float2 colorTL = tex - tex % downscaled;
  float luma = (color.r + color.g + color.b) * 0.33;
  float4 colorAVG =
    0.25 * (tex2D(s0, tex) +
    tex2D(s0, float2(tex.x + 1.0 / width, tex.y)) +
    tex2D(s0, float2(tex.x, tex.y + 1.0 / height)) +
    tex2D(s0, float2(tex.x + 1.0 / width, tex.y + 1.0 / height)));
  float pixelLuma = luma / ((colorAVG.r + colorAVG.g + colorAVG.b) * 0.33);
  return colorAVG * pixelLuma;
}

float4 halfRes(float2 tex) {
  float2 halfPixelSize = float2(2.0 / width, 2.0 / height);
  return tex2D(s0, tex - tex % halfPixelSize);
}

float4 main(float2 tex : TEXCOORD0) : COLOR {
  float otex = tex.x;
  tex.x = 0.375 + tex.x % 0.25;
	float4 result = otex < 0.5 ? halfRes(tex) : tex2D(s0, tex);
  return otex.x % 0.5 < 0.25 ? halfColor(result, tex, otex.x < 0.5 ? 4 : 2) : result;
}

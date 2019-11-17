/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Left eye retain for half-size over-under 3D content
*/

sampler s0;
float4 p0 : register(c0);

#define height (p0[1])

float4 main(float2 tex : TEXCOORD0) : COLOR {
	tex.y *= .5;
  float3 leftPixel = tex2D(s0, tex).rgb;
  tex.y += 1. / height;
	return (tex.y * height) % 1 < .5 ? leftPixel.rgbb : (leftPixel + tex2D(s0, tex).rgb).rgbb * .5;
}
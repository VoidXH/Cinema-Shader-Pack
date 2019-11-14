/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Keep content in the screen's largest given area by ratio
*/

// Configuration ---------------------------------------------------------------
const static float targetRatio = 16.0/9; // Frame ratio to keep the content in
// -----------------------------------------------------------------------------

sampler s0;
float4 p0 : register(c0);

#define width (p0[0])
#define height (p0[1])

float4 main(float2 tex : TEXCOORD0) : COLOR {
  float ratio = width / height;
  float scale = ratio > targetRatio ? ratio / targetRatio : (targetRatio / ratio);
  float offset = (scale - 1) * 0.5;
  tex = tex * scale - float2(offset, offset);
  return tex.x >= 0.0 && tex.x <= 1.0 && tex.y >= 0.0 && tex.y <= 1.0 ? tex2D(s0, tex).rgbb : float4(0,0,0,0);
}
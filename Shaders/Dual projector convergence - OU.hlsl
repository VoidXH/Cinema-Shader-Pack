/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Simple projector convergence for over-under dual projection (3D or HDR)
*/

// Configuration ---------------------------------------------------------------
const static float secX = 0; // Secondary projector offset on X axis
const static float secY = 0.05; // Secondary projector offset on Y axis
// -----------------------------------------------------------------------------

sampler s0;

float4 main(float2 tex : TEXCOORD0) : COLOR {
  float ot = tex.y;
  tex.x = ot > 0.5 ? tex.x - secX : tex.x;
  tex.y = ot > 0.5 ? tex.y - secY : tex.y;
  return tex.x >= 0 && tex.y >= 0 && tex.x <= 1 && tex.y <= 1 ? tex2D(s0, tex).rgbb : float4(0,0,0,0);
}
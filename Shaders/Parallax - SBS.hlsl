/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Parallax correction for side-by-side 3D content
*/

// Configuration ---------------------------------------------------------------
static const float parallax = -.01; // Parallax offset ratio, +: closer, -: deeper, logical limits: [-.05; .05]
static const float focus = 0; // Focus point offset ratio
// -----------------------------------------------------------------------------

sampler s0;

float4 main(float2 tex : TEXCOORD0) : COLOR {
  // separation with parallax settings
  float otex = tex.x;
	float texr = tex.x + .5;
  float parallaxRange = 1. + (parallax > 0 ? -parallax : parallax);
  tex.x = clamp((((parallax >= 0) ? focus : focus - parallax) + tex.x / .5 * parallaxRange) * .5, 0, .5);
  texr = clamp((((parallax >= 0) ? parallax - focus : -focus) + (texr - 1) / .5 * parallaxRange) * .5 + .5, .5, 1);

  // merge
  tex.x = tex.x < .5 ? tex.x : texr;
	return (tex2D(s0, tex)).rgbb;
}
/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Simple gamma correction
*/

// Configuration ---------------------------------------------------------------
const static float sourceGamma = 1.6; // Original gamma (most projectors are in the 1.6-1.8 range)
const static float targetGamma = 2.2; // Target gamma level
      // Possible target candidates are:
      // 2.2 - Used for low-end panels which fail to show distinguishable blacks
      // 2.4 - TV standard
      // 2.6 - DCI standard
// -----------------------------------------------------------------------------

// Precalculated value
const static float correction = targetGamma / sourceGamma;

sampler s0;

float4 main(float2 tex : TEXCOORD0) : COLOR { 
	return pow((tex2D(s0, tex)).rgbb, correction);
}
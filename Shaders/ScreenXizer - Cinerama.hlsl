/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Warp screen edges to side screens with cylinder wrapping
*/

// Configuration ---------------------------------------------------------------
const static float expand = 0.3; // Ratio to scale to sides
const static float sideFactor = 2.0; // Move contents on the sides to the front of the given side
const static float projection = 0; // 1 for projection, 0 for single screen demo
// -----------------------------------------------------------------------------

sampler s0;

float4 main(float2 tex : TEXCOORD0) : COLOR {
  tex.y = projection > 0.5 ? tex.y :
            tex.x < 1.0/3.0 ? (tex.y * (1.0/3.0 + tex.x * 2.0) + expand / 6.0 - tex.x) * 3.0 * (1.0 - expand) : (
            tex.x < 2.0/3.0 ? (tex.y + expand / 6.0 - 1.0/3.0) * 3.0 * (1.0 - expand) : (
                              (tex.y * (1.0 - (tex.x - 2.0/3.0) * 2.0) + expand / 6.0 - 1.0/3.0 - (2.0/3.0 - tex.x)) * 3.0 * (1.0 - expand)
  ));
  tex.x = tex.x < 1.0/3.0 ? pow(tex.x * 3.0, sideFactor) * expand * 0.5 : (
          tex.x < 2.0/3.0 ? ((tex.x - 1.0/3.0) * 3.0) / (1.0 / (1.0 - expand)) + expand * 0.5 : (
                            (1.0 - pow(1.0 - (tex.x - 2.0/3.0) * 3.0, sideFactor)) * expand * 0.5 + (1.0 - expand * 0.5)
          )
  );
  return tex.y >= 0.0 && tex.y <= 1.0 ? tex2D(s0, tex).rgbb : float4(0,0,0,0);
}
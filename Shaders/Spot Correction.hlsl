/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Corrects spots with incorrect colors
*/

// Configuration ---------------------------------------------------------------
const static float referenceX = 1920; // Reference screen width
const static float referenceY = 1080; // Reference screen height
const static float spotX = 600; // Spot center at reference width
const static float spotY = 564; // Spot center at reference height
const static float radiusX = 400; // Width of the screen covered in the spot
const static float radiusY = 400; // Height of the screen covered in the spot
const static float redMul = 1.0; // Red multiplier (for cyan spots)
const static float greenMul = 1.0; // Green multiplier (for magenta spots)
const static float blueMul = 1.3; // Blue multiplier (for yellow spots)
// -----------------------------------------------------------------------------

sampler s0;
float4 p0 : register(c0);

#define width (p0[0])
#define height (p0[1])

float4 main(float2 tex : TEXCOORD0) : COLOR {
  float heightDiff = (width * referenceY) / (height * referenceX);
  float2 pos = float2(spotX / referenceX, spotY / referenceY - (heightDiff - 1) * 0.5);
  float2 r = float2(radiusX / referenceX, radiusY / referenceY * heightDiff);
  float2 dist = float2((pos.x - tex.x) / r.x, (pos.y - tex.y) / r.y);
  float wetness = max(1 - sqrt(dist.x * dist.x + dist.y * dist.y), 0);
  float3 wet = tex2D(s0, tex).rgb * float3(redMul, greenMul, blueMul);
  return tex2D(s0, tex).rgbb * (1 - wetness) + wet.rgbb * wetness;
}
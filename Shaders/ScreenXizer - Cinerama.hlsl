/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: Warp screen edges to side screens with cylinder wrapping
*/

// Configuration ---------------------------------------------------------------
const static float expand = 0.3; // Ratio of the whole image width to scale to both sides
const static float edgeFactor = 2.0; // Warp this much more to the edges
const static float projection = 0; // 1 for projection, 0 for single screen demo
const static float middleRatio = 1.0 / 3.0; // Ratio of the undistorted content in the center relative to the screen size
// -----------------------------------------------------------------------------

// Precalculated values
const static float sideSquash = 1.0 - middleRatio; // Scale back sides by this much not to overshoot the screen
const static float sidePartWidth = sideSquash * 0.5;
const static float rightPartFrom = 1.0 - sidePartWidth;
const static float sidePart = expand * 0.5; // Ratio of one side expansion to the original width
const static float middlePart = 1.0 - expand; // Ratio of the unwarped image to the original width
const static float middleScale = middlePart / middleRatio; // When the middle part is retained, this is the height scale to get back the original aspect ratio
const static float sideScale = 1.0 / sidePartWidth; // Scales side coordinates to the 0-1 range

sampler s0;

inline float scaleFromCenter(float what, float with) {
  return (what - 0.5) * with + 0.5;
}

float4 main(float2 tex : TEXCOORD0) : COLOR {
  float left = tex.x < sidePartWidth;
  float right = tex.x > rightPartFrom;
  float middle = left == right;
  float visible = 1.0;

  if (projection < 0.5) {
    float leftY = scaleFromCenter(tex.y, tex.x * sideScale * sideSquash + middleRatio);
    float rightY = scaleFromCenter(tex.y, (1.0 - tex.x) * sideScale * sideSquash + middleRatio);
    tex.y = scaleFromCenter(left * leftY + middle * tex.y + right * rightY, middleScale);
    visible = tex.y >= 0.0 && tex.y <= 1.0;
  }

  float leftX = pow(tex.x * sideScale, edgeFactor) * sidePart;
  float middleX = scaleFromCenter(tex.x, middleScale);
  float rightX = 1.0 - pow((1.0 - tex.x) * sideScale, edgeFactor) * sidePart;
  tex.x = left * leftX + middle * middleX + right * rightX;

  return visible * tex2D(s0, tex).rgbb + (1 - visible) * float4(0,0,0,0);
}

/*
   _______                               _____ __              __             ____             __
  / ____(_)___  ___  ____ ___  ____ _   / ___// /_  ____ _____/ /__  _____   / __ \____ ______/ /__
 / /   / / __ \/ _ \/ __ `__ \/ __ `/   \__ \/ __ \/ __ `/ __  / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /___/ / / / /  __/ / / / / / /_/ /   ___/ / / / / /_/ / /_/ /  __/ /     / ____/ /_/ / /__/ ,<
\____/_/_/ /_/\___/_/ /_/ /_/\__,_/   /____/_/ /_/\__,_/\__,_/\___/_/     /_/    \__,_/\___/_/|_|
        http://en.sbence.hu/        Shader: 6-point single projector geometry correction
*/

// Projector configuration -----------------------------------------------------
const static float chipAspect = 1.778; // width / height
// Projection offset correction ------------------------------------------------
const static float horizontalCorrection = 0.985;
const static float verticalCorrection = 1.0;
// Corner offsets (inwards, ratio, relative to full frame) ---------------------
const static float topLeftDown = 0.005;
const static float topLeftRight = 0.0;
const static float topRightDown = 0.0;
const static float topRightLeft = 0.0;
const static float bottomLeftUp = 0.005;
const static float bottomLeftRight = 0.02;
const static float bottomRightUp = 0.0;
const static float bottomRightLeft = 0.012;
// Barrel correction -----------------------------------------------------------
const static float topBarrel = 0.005;
const static float bottomBarrel = 0;
const static float barrelCurviness = 2.0;
// -----------------------------------------------------------------------------

// Precalculated values
const static float topWidth = 1.0 + topLeftRight + topRightLeft;
const static float leftHeight = 1.0 + topLeftDown + bottomLeftUp;
const static float rightHeight = 1.0 + topRightDown + bottomRightUp;
const static float barrelThroat = 1.0 + topBarrel + bottomBarrel;

sampler s0 : register(s0);
float4 p0 : register(c0);

#define width (p0[0])
#define height (p0[1])

inline float4 getTex(float2 tex) {
  return tex.x >= 0 && tex.x <= 1 && tex.y >=0 && tex.y <= 1 ? tex2D(s0, tex) : 0;
}

float4 main(float2 tex : TEXCOORD0) : COLOR {
  float heightDown = tex.y;
  float heightUp = 1.0 - tex.y;
  float widthRight = tex.x;
  float widthLeft = 1.0 - tex.x;

  // Aspect ratio
  float videoAspect = width / height;
  float aspectCorrection = chipAspect / videoAspect;
  float fixBLR = bottomLeftRight * aspectCorrection;
  float fixBRL = bottomRightLeft * aspectCorrection;
  float bottomWidth = 1.0 + fixBLR + fixBRL;

  // Horizontal edge warps
  float widthScale = heightUp * topWidth + heightDown * bottomWidth;
  float widthMargin = heightUp * topLeftRight + heightDown * fixBLR;
  tex.x = widthScale * widthRight - widthMargin;

  // Vertical edge warps
  float heightScale = widthLeft * leftHeight + widthRight * rightHeight;
  float heightMargin = widthLeft * topLeftDown + widthRight * topRightDown;
  tex.y = heightScale * heightDown - heightMargin;

  // Barrel
  float centerDist = pow(abs(tex.x - 0.5) * 2.0, barrelCurviness);
  float centerness = 1.0 - centerDist;
  float barrelScale = centerDist + centerness * barrelThroat;
  float barrelMargin = centerness * topBarrel;
  tex.y = barrelScale * tex.y - barrelMargin;
  
  // Projection offset warp
  tex.x = tex.x >= 0 ? pow(tex.x, horizontalCorrection) : -1;
  tex.y = tex.y >= 0 ? pow(tex.y, verticalCorrection) : -1;

  // Anti-aliased output with standard 8x MSAA pattern
  float2 px = float2(1.0 / width, 1.0 / height); // pixel size
  float4 aa1 = getTex(tex + float2(px.x * 0.1, px.x * -0.3));
  float4 aa2 = getTex(tex + float2(px.x * -0.1, px.x * 0.3));
  float4 aa3 = getTex(tex + float2(px.x * 0.5, px.x * 0.1));
  float4 aa4 = getTex(tex + float2(px.x * -0.3, px.x * -0.5));
  float4 aa5 = getTex(tex + float2(px.x * -0.5, px.x * 0.5));
  float4 aa6 = getTex(tex + float2(px.x * -0.7, px.x * -0.1));
  float4 aa7 = getTex(tex + float2(px.x * 0.3, px.x * 0.7));
  float4 aa8 = getTex(tex + float2(px.x * 0.7, px.x * -0.7));

  return (aa1 + aa2 + aa3 + aa4 + aa5 + aa6 + aa7 + aa8) * 0.125;
}
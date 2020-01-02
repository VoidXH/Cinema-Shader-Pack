# Cinema Shader Pack
HLSL shaders for projection corrections and dual-projector 3D/HDR.

## Shader categories
The supplied shaders can be grouped by the order they should be applied on the video. Each group has different usage rules. Any group can be skipped.

1. Splitters<br />
   Splitters create an image pair that can be dual-projected. Only one splitter can be applied in the shader chain.
   * [S-Log to SDR + overexposure](./Shaders/S-Log%20to%20SDR%20+%20overexposure.hlsl): Try to get the SDR part of S-Log HDR content with overexposure as SBS 3D
2. Split state corrections<br />
   These shaders process already split videos like 3D content, for multiple properties.
   * [Dual projector convergence - SBS](./Shaders/Dual%20projector%20convergence%20-%20SBS.hlsl): Simple projector convergence for side-by-side dual projection (3D or HDR)
   * [Flip eyes - OU](./Shaders/Flip%20eyes%20-%20OU.hlsl): Flip left/right eye image for over-under 3D content
   * [Flip eyes - SBS](./Shaders/Flip%20eyes%20-%20SBS.hlsl): Flip left/right eye image for side-by-side 3D content
   * [Parallax - OU](./Shaders/Parallax%20-%20OU.hlsl): Parallax correction for over-under 3D content
   * [Parallax - SBS](./Shaders/Parallax%20-%20SBS.hlsl): Parallax correction for side-by-side 3D content
3. Mergers<br />
   Mergers combine split images. Only one merger for the given source and target format can be applied in the shader chain.
   * [3D to 2D - OU](./Shaders/3D%20to%202D%20-%20OU.hlsl): Left eye retain for half-size over-under 3D content
   * [3D to 2D - SBS](./Shaders/3D%20to%202D%20-%20SBS.hlsl): Left eye retain for half-size side-by-side 3D content
   * [Anaglyph 3D - OU to red-blue](./Shaders/Anaglyph%203D%20-%20OU%20to%20red-blue.hlsl): Prepare over-under 3D content for red-blue glasses
   * [Anaglyph 3D - OU to red-cyan](./Shaders/Anaglyph%203D%20-%20OU%20to%20red-cyan.hlsl): Prepare over-under 3D content for red-cyan glasses
   * [Anaglyph 3D - OU to red-green](./Shaders/Anaglyph%203D%20-%20OU%20to%20red-green.hlsl): Prepare over-under 3D content for red-green glasses
   * [Anaglyph 3D - OU to trioscopic](./Shaders/Anaglyph%203D%20-%20OU%20to%20trioscopic.hlsl): Prepare over-under 3D content for trioscopic glasses
   * [Anaglyph 3D - SBS to red-blue](./Shaders/Anaglyph%203D%20-%20SBS%20to%20red-blue.hlsl): Prepare side-by-side 3D content for red-blue glasses
   * [Anaglyph 3D - SBS to red-cyan](./Shaders/Anaglyph%203D%20-%20SBS%20to%20red-cyan.hlsl): Prepare side-by-side 3D content for red-cyan glasses
   * [Anaglyph 3D - SBS to red-green](./Shaders/Anaglyph%203D%20-%20SBS%20to%20red-green.hlsl): Prepare side-by-side 3D content for red-green glasses
   * [Anaglyph 3D - SBS to trioscopic](./Shaders/Anaglyph%203D%20-%20SBS%20to%20trioscopic.hlsl): Prepare side-by-side 3D content for trioscopic glasses
4. Corrections<br />
   Single-projector or merged image corrections for multiple properties.
   * [Gamma Correction](./Shaders/Gamma%20Correction.hlsl): Simple gamma correction
   * [Reframe](./Shaders/Reframe.hlsl): Keep content in the screen's largest given area by ratio
   * [Screen File](./Shaders/Screen%20File.hlsl): 6-point single projector geometry correction
   * [S-Log to SDR](./Shaders/S-Log%20to%20SDR.hlsl): Try to get the SDR part of S-Log HDR content
5. Warpers<br />
   Specific splitters for special setups, including triple projection.
   * [ScreenXizer - Cinerama](./Shaders/ScreenXizer%20-%20Cinerama.hlsl): Warp screen edges to side screens with cylinder wrapping
   * [ScreenXizer - Cubemap](./Shaders/ScreenXizer%20-%20Cubemap.hlsl): Warp screen edges to side screens with cube wrapping

## Licence
The source code is given to you for free, but without any warranty. It is not guaranteed to work, and the developer is not responsible for any damages from the use of the software. You are allowed to make any modifications, and release them for free. If you release a modified version, you have to link this repository as its source. You are not allowed to sell any part of the original or the modified version. You are also not allowed to show advertisements in the modified software. If you include these code or any part of the original version in any other project, these terms still apply.

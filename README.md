# Cinema Shader Pack
HLSL shaders for projection corrections and dual-projector 3D/HDR.

## Table of contents
1. How to use
2. Shader categories
3. HDR tutorial
4. Licence

## 1. How to use
Copy the contents of the Shaders folder to the Shaders folder of a media player
that supports HLSL, like MPC-HC. Go to the shader settings and add the selected
ones as post-resize shaders.

Some shaders can be configured. Open them with any text editor and modify the
values under *Configuration* if it's present.

## 2. Shader categories
The supplied shaders can be grouped by the order they should be applied on the
video. Only use the selected shaders in the order they appear here. Each group
has different usage rules. Any group can be skipped.

1. Splitters<br />
   Splitters create an image pair that can be dual-projected. Only one splitter can be applied in the shader chain.
   * [HDR to SDR + overexposure](./Shaders/HDR%20to%20SDR%20+%20overexposure.hlsl): Try to get the SDR part of HDR content with overexposure as SBS 3D
   * [Resolution demo](./Shaders/Resolution%20demo.hlsl): Shows half resolution 4:2:0, 4:4:4, full resolution 4:2:0, and 4:4:4 in order
2. Split state corrections<br />
   These shaders process already split videos like 3D content, for multiple properties.
   * [Dual projector convergence - OU](./Shaders/Dual%20projector%20convergence%20-%20OU.hlsl): Simple projector convergence for over-under dual projection (3D or HDR)
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
   * [Black bar filler](./Shaders/Black%20bar%20filler.hlsl): Fill black bars by cylindrically warping the image
   * [Bottomizer](./Shaders/Bottomizer.hlsl): Move wide content to the bottom of the frame
   * [HDR to SDR](./Shaders/HDR%20to%20SDR.hlsl): Try to get the SDR part of HDR content
   * [HDR to SDR (vibrant)](./Shaders/HDR%20to%20SDR%20(vibrant).hlsl): HDR to SDR with a different, sometimes better looking compressor
   * [HDR to SDR (S-Log)](./Shaders/HDR%20to%20SDR%20(S-Log).hlsl): Try to get the SDR part of S-Log HDR content
   * [Gamma correction](./Shaders/Gamma%20correction.hlsl): Simple gamma correction
   * [Reframe](./Shaders/Reframe.hlsl): Keep content in the screen's largest given area by ratio
   * [Screen file](./Shaders/Screen%20file.hlsl): 6-point single projector geometry correction
   * [Spot correction](./Shaders/Spot%20correction.hlsl): Corrects spots with incorrect colors
5. Warpers<br />
   Specific splitters for special setups, including triple projection.
   * [ScreenXizer - Cinerama](./Shaders/ScreenXizer%20-%20Cinerama.hlsl): Warp screen edges to side screens with cylinder wrapping
   * [ScreenXizer - Cubemap](./Shaders/ScreenXizer%20-%20Cubemap.hlsl): Warp screen edges to side screens with cube wrapping

## 3. HDR tutorial
The *HDR to SDR* shader works for both SDR conversion and limited to full HDR
content display. The default configuration values are fine for regular displays,
but you can set it up to actual HDR light values, even to luminance levels not
supported by today's standards, making this shader future-proof. To get the most
out of your screen, push the light output to the maximum and set the peak
luminance accordingly. If you don't have a luminance meter, just set it to the
largest value where the shadows look right.

## 4. Licence
The source code is given to you for free, but without any warranty. It is not
guaranteed to work, and the developer is not responsible for any damages from
the use of the software. You are allowed to make any modifications, and release
them for free. If you release a modified version, you have to link this
repository as its source. You are not allowed to sell any part of the original
or the modified version. You are also not allowed to show advertisements in the
modified software. If you include these code or any part of the original version
in any other project, these terms still apply.

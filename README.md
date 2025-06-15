## Usage

1. Clone this repo, or just copy the .glsl shader as well as the .gd file into your project

2. If necessary, change the path of the .glsl shader in `_initialize_compute()` so it points to the location of `linear_to_di.glsl` in your project

3. In your WorldEnvironment, make sure Tonemap is set to Linear and that exposure is set to 1.0

4. In your WorldEnvironment again, create a Compositor, then a CompositorEffect. You should now see a new option called "PostProcessLinearToDI"; Click on it

![image](https://github.com/user-attachments/assets/70c61c4e-d6d0-47a0-a0f6-7bbfbf807ee9)

Your viewport should now look something like this:

![image](https://github.com/user-attachments/assets/f6bd7313-8c1b-4203-a186-5d6d3645dfeb)

Now if you want to create your own LUT in Resolve, I recommend taking an EXR screenshot with this piece of code:
```
var viewport = get_viewport()

viewport.size = Vector2(3840, 2160)
viewport.get_texture().get_image().save_exr('screenshot.exr')
```

Once that's done, you can import the EXR into DaVinci Resolve/Resolve Studio and grade to your heart's content:

![image](https://github.com/user-attachments/assets/538176b0-5131-4048-b65c-fb37ac6f49cb)

Make sure your CST's input color space is sRGB, input gamma is **DaVinci Intermediate**, output color space is set to sRGB or Rec709, and finally output gamma should be sRGB or Gamma 2.2

Then finally, to export your LUT, right click on your graded clip, go to Generate > 65 Point CUBE

![image](https://github.com/user-attachments/assets/76cb597f-6def-4ca0-99a3-59326c5b9f3b)

Then head to the Fusion tab:

1. Disconnect the MediaIn node if necessary
2. Add a LUTCubeCreator node, set it to horizontal and whatever size you want (most people recommend 33, 51 or 65)
3. Then, add a FileLUT node with the .cube you exported earlier
4. Add a Transform node (under Tools > Transform > Transform) and set it to flip vertically
5. Connect all the nodes, you should now see your LUT applied and the LUT strip flipped
6. Right click on the LUT displayed in the viewport, and save it as a TGA or PNG file

![image](https://github.com/user-attachments/assets/60ae8acf-6b22-4524-8d75-dd1200829bbb)



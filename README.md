# 3D-Rendering
This is an attempt to create a **3D-Rendering** inspired on **Doom**

![demo](media/demo.gif)


I want this engine to be *"re-writable"* using other languages and frameworks.
That's why there are some warnings in the `main.lua` file

```
-= WARNINGS =-
Since I want this to be portable this are some warnings of changes you might need to
do on porting to another framework/language

OBS.: Where Y is originally '+' it changes to '-'
- Since OpenGL and Love2D 'Y coords' are inverted (for some reason)
	+ I added a "Y!" warning to where I changed the Y followed by "original operator"
	+ In fact this just changes the order of drawing sectors and movement
- Almost all variables are Integer, except the ones with [F!]
	+ This is important to know because there are some operations that if uses float will cause bugs
- General warnings on converting to OpenGL are prefixed with [!] followed by the "what do in OpenGL"
```

### Why Love2D?
`Lua` is one of my favorite languages for many reasons, and it's the language I feel most comfortable using for making games

## State of the project
- [X] Movement
- [X] Basic Rendering
- [X] Wall and **Top/Bottom Surfaces**
- [X] Textures
- [X] Load levels from **File**
- [ ] Billboarding
- [ ] More...


# Running
Install `Love2D` and run it from the root directory

# Credits
Inspired by [3DSage](https://github.com/3DSage/OpenGL-Doom_tutorial_part_2)

Using his **Level Editor** [Grid2D](https://github.com/3DSage/OpenGL-Doom_tutorial_part_2/blob/main/Grid2D.c)


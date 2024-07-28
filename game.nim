# Deps
import raylib, raymath, std/math

# Some important templates
template `//`(a, b: untyped) : untyped = a div b
template `%`(a, b: untyped) : untyped = a mod b

const
  screen_width = 800
  screen_height = 600
  FPS = 120


# Initialise
initWindow(screen_width, screen_height, "My first Raylib game!")
setTargetFPS(FPS)



# Declare constants {{{
const
  logoPositionX:int32 = screen_width // 2 - 128
  logoPositionY:int32 = screen_height // 2 - 128
  FP6 = FPS//120

var atlas = loadImage("resources/blocks.png")
imageFlipVertical(atlas)
var grassSide = loadImage("datapack/assets/minecraft/textures/block/grass_block_side.png")
imageFlipVertical(grassSide)

let
  blockAtlas = loadTextureFromImage(atlas)
  #grassImage = imageFromImage(atlas, Rectangle(x:6944, y:144, width:16, height:16))
  grass = loadTextureFromImage(grassSide)
#}}}

# Declare variables {{{1
var
  camera = Camera(
    position: Vector3(x: 0, y: 50, z: -120), # Camera position perspective
    target: Vector3(x: 0, y: 0, z: 0),       # Camera looking at point
    up: Vector3(x: 0, y: 1, z: 0),           # Camera up vector (rotation towards target)
    fovy: 30,                                # Camera field-of-view Y
    projection: Perspective                  # Camera type
  )
  cubePos = Vector3(x:0, y:5, z:0)

  framesCounter:int = 0
  lettersCount:int = 0

  topSideRecWidth:int32 = 16
  leftSideRecHeight:int32 = 16

  bottomSideRecWidth:int32 = 16
  rightSideRecHeight:int32 = 16

  state:int = 0

  alpha:float64 = 1

  isCursorLocked:bool = false

  rotation:float = 0
#  cubeMesh = genMeshCube(10, 10, 0)
#[
for i in 0 .. 24:
  cubeMesh.texcoords[i] = Vector2(x:2.0, y:0.0)

]#
#var cube = loadModelFromMesh(cubeMesh)

# Set any additional values {{{2
var planeArray :array[0..6, Model]
planeArray[0] = loadModelFromMesh(genMeshCube(10, 10, 0))
planeArray[1] = loadModelFromMesh(genMeshCube(0, 10, 10))

planeArray[0].materials[0].maps[Material_Map_Index.Diffuse].texture = grass
planeArray[1].materials[0].maps[Material_Map_Index.Diffuse].texture = grass
#}}}

#}}}


# Set important flags
setConfigFlags(flags(Msaa_4x_Hint))

# Do Logo Animation {{{
proc AnimateLogo =
  if state == 0:
    framesCounter += 1
    if (framesCounter == (FPS*2)):
      state = 1
      framesCounter = 0
  elif state == 1:
    topSideRecWidth += 4 // (FP6)
    leftSideRecHeight += 4 // (FP6)
    if leftSideRecHeight == 256:
      state = 2
  elif state == 2:
    bottomSideRecWidth += 4 // (FP6)
    rightSideRecHeight += 4 // (FP6)
    if bottomSideRecWidth == 256:
      state = 3
  elif state == 3:
    framesCounter += 1
    if lettersCount < 10:
      if framesCounter  == 24:
        lettersCount += 1
        framesCounter = 0
    if lettersCount >= 10:
      alpha -= 0.01
      if alpha <= 0:
        alpha = 0
        state = 4
  if state < 4:
   drawing():
     clearBackground(RayWhite)

     if state == 0:
       if framesCounter // (15*FP6) % 2 == 0:
         drawRectangle(logoPositionX, logoPositionY, 16, 16, Black)

     if state == 1:
       drawRectangle(logoPositionX, logoPositionY, topSideRecWidth, 16, Black)
       drawRectangle(logoPositionX, logoPositionY, 16, leftSideRecHeight, Black)

     elif state == 2:
       drawRectangle(logoPositionX, logoPositionY, topSideRecWidth, 16, Black)
       drawRectangle(logoPositionX, logoPositionY, 16, leftSideRecHeight, Black)

       drawRectangle(logoPositionX + 240, logoPositionY, 16, rightSideRecHeight, Black)
       drawRectangle(logoPositionX, logoPositionY + 240, bottomSideRecWidth, 16, Black)

     elif state == 3:
       drawRectangle(logoPositionX, logoPositionY, topSideRecWidth, 16, fade(Black, alpha));
       drawRectangle(logoPositionX, logoPositionY + 16, 16, leftSideRecHeight - 32, fade(Black, alpha));

       drawRectangle(logoPositionX + 240, logoPositionY + 16, 16, rightSideRecHeight - 32, fade(Black, alpha));
       drawRectangle(logoPositionX, logoPositionY + 240, bottomSideRecWidth, 16, fade(Black, alpha));

       drawRectangle(getScreenWidth()//2 - 112, getScreenHeight()//2 - 112, 224, 224, fade(RayWhite, alpha));

       drawText(substr("raylib", 0, lettersCount), getScreenWidth()//2 - 44, getScreenHeight()//2 + 48, 50, fade(Black, alpha));

       if lettersCount >= 6:
         drawText("powered by", logoPositionX, logoPositionY - 27, 20, fade(DarkGray, alpha));
#}}}


# Main fucntion {{{
proc main =

  while not windowShouldClose():
    # Update variables
    var delta = getFrameTime()

    # Do Logo Animation
    AnimateLogo()

    if state == 4:
      # Main game loop after logo intro
      if not isCursorLocked:
        disableCursor()
        isCursorLocked = true
      updateCamera(camera, Free)

      # Boilerplate drawing code

      drawing():
        clearBackground(RayWhite)

        # Actual drawing

        mode3D(camera):
          # 3D
          #drawModel(cube, Vector3(x:15, y:5, z:0), 1, White)
          drawModel(planeArray[0], Vector3(x:0, y:5, z:0-5), 1, White)
          drawModel(planeArray[0], Vector3(x:0, y:5, z:5), 1, White)
          drawModel(planeArray[1], Vector3(x:0-5, y:5, z:0), 1, White)
          drawModel(planeArray[1], Vector3(x:5, y:5, z:0), 1, White)
          drawGrid(10, 9)
          #drawCube(cubePos, Vector3(x:10, y:10, z:10), Red)
          #drawCubeWires(cubePos, Vector3(x:5, y:5, z:0), Black)

  # Close window and deinitialise
  closeWindow()
#}}}

main()

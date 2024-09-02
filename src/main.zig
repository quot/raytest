const rl = @import("raylib");

var camera = rl.Camera3D{
    .position = rl.Vector3.init(10, 10, 10),
    .target = rl.Vector3.init(0, 0, 0),
    .up = rl.Vector3.init(0, 1, 0),
    .fovy = 45,
    .projection = rl.CameraProjection.camera_perspective,
};

pub fn main() anyerror!void {
    const screenWidth = 1920;
    const screenHeight = 1080;

    rl.initWindow(screenWidth, screenHeight, "RayTest");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        appUpdate();
        appDraw();
    }
}

pub fn appUpdate() void {
    if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_right)) {
        camera.update(rl.CameraMode.camera_free);
    }

    if (rl.isKeyPressed(rl.KeyboardKey.key_z)) {
        camera.target = rl.Vector3.init(0, 0, 0);
    }
}

pub fn appDraw() void {
    rl.beginDrawing();
    defer rl.endDrawing();

    rl.clearBackground(rl.Color.ray_white);
    rl.drawFPS(0, 0);

    {
        camera.begin();
        defer camera.end();

        rl.drawCube(rl.Vector3.init(0, 0, 0), 2, 2, 2, rl.Color.red);
        rl.drawGrid(10, 1);
    }
}

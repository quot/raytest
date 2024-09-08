const math = @import("std").math;
const rl = @import("raylib");

const fovDefault = 45.0;
const fovMin = 10.0;
const fovMax = 90;

pub fn main() anyerror!void {
    // Window Setup
    rl.initWindow(1920, 1080, "RayTest");
    defer rl.closeWindow(); // Close window and OpenGL context

    var camera = rl.Camera3D{
        .position = rl.Vector3.init(2, 1.5, 2),
        .target = rl.Vector3.init(0, 0, 0),
        .up = rl.Vector3.init(0, 1, 0),
        .fovy = 45,
        .projection = rl.CameraProjection.camera_perspective,
    };

    // UI
    rl.setTargetFPS(90); // Set our game to run at 60 frames-per-second

    // Assets
    const barrelModel = rl.loadModel("assets/barrel.obj");
    defer barrelModel.unload();

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        cameraUpdate(&camera);

        // DRAW
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.ray_white);
        rl.drawFPS(0, 0);

        {
            camera.begin();
            defer camera.end();

            // rl.drawModel(barrelModel, rl.Vector3.init(0, 0, 0), 1, rl.Color.white);
            barrelModel.draw(rl.Vector3.init(0, 0, 0), 1, rl.Color.white);
            barrelModel.drawWires(rl.Vector3.init(0, 0, 0), 1, rl.Color.black);

            // rl.drawCube(rl.Vector3.init(0, 0, 0), 2, 2, 2, rl.Color.red);
            rl.drawGrid(10, 1);
        }
    }
}

pub fn cameraUpdate(camera: *rl.Camera3D) void {
    if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_right)) {
        camera.update(rl.CameraMode.camera_free);
    }

    if (rl.isKeyPressed(rl.KeyboardKey.key_z)) {
        camera.target = rl.Vector3.init(0, 0, 0);
    }

    if (rl.isMouseButtonPressed(rl.MouseButton.mouse_button_middle)) {
        camera.fovy = fovDefault;
    } else {
        camera.fovy = math.clamp((camera.fovy + (rl.getMouseWheelMove() * -1.5)), fovMin, fovMax);
    }
}

const std = @import("std");
const rl = @import("raylib");
const math = std.math;

// TODO: Move out of global scope
const fovDefault = 45.0;
const fovMin = 10.0;
const fovMax = 90;

const cameraFocus = rl.Vector3.init(0, 0, 0);
const cameraStartPos = rl.Vector3.init(2, 1.5, 2);
const cameraZoomDistMax = 10.0;
const cameraZoomDistMin = 1.0;
const cameraZoomClampTolerance = 0.2;

pub fn main() anyerror!void {
    ///////////////////////////////////////////////////////////////////////////
    // Setup //
    ///////////

    // Window Setup
    rl.initWindow(1920, 1080, "RayTest");
    defer rl.closeWindow(); // Close window and OpenGL context
    rl.setTargetFPS(90); // Set our game to run at 60 frames-per-second

    // Camera
    var camera = rl.Camera3D{
        .position = cameraStartPos,
        .target = cameraFocus,
        .up = rl.Vector3.init(0, 1, 0),
        .fovy = 45,
        .projection = rl.CameraProjection.camera_perspective,
    };

    // Assets
    const barrelModel = rl.loadModel("assets/barrel.obj");
    defer barrelModel.unload();

    ///////////////////////////////////////////////////////////////////////////
    // Game Loop //
    ///////////////

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        cameraUpdate(&camera);

        // DRAW
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.ray_white);
        // rl.drawFPS(0, 0);

        rl.drawText(rl.textFormat("%03i", .{@as(i32, @intFromFloat(camera.position.distance(cameraFocus)))}), 0, 0, 20, rl.Color.magenta);

        {
            camera.begin();
            defer camera.end();

            barrelModel.draw(rl.Vector3.init(0, 0, 0), 1, rl.Color.white);
            barrelModel.drawWires(rl.Vector3.init(0, 0, 0), 1, rl.Color.black);

            // rl.drawCube(rl.Vector3.init(0, 0, 0), 2, 2, 2, rl.Color.red);
            rl.drawGrid(10, 1);
        }
    }
}

pub fn cameraUpdate(camera: *rl.Camera3D) void {
    if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_middle)) {
        camera.update(rl.CameraMode.camera_third_person);
    } else if (rl.isMouseButtonDown(rl.MouseButton.mouse_button_right)) {
        // TODO: Move cameraFocus location
        camera.update(rl.CameraMode.camera_free);
    }

    const curDist = camera.position.distance(cameraFocus);
    var moveDist = rl.getMouseWheelMove() * 0.2;
    if (moveDist != 0) {
        if (moveDist > 0) {
            moveDist = @min((curDist - cameraZoomDistMin), moveDist);
            camera.position = camera.position.moveTowards(cameraFocus, moveDist);
        } else {
            moveDist = @max((curDist - cameraZoomDistMax), moveDist);
            camera.position = camera.position.moveTowards(cameraFocus, moveDist);
        }

        if (camera.position.distance(cameraFocus) < (cameraZoomDistMin - cameraZoomClampTolerance)) {
            camera.position = cameraStartPos;
        }
    }

    if (rl.isKeyPressed(rl.KeyboardKey.key_z)) {
        camera.target = rl.Vector3.init(0, 0, 0);
    }

    // if (rl.isMouseButtonPressed(rl.MouseButton.mouse_button_middle)) {
    //     camera.fovy = fovDefault;
    // } else {
    //     camera.fovy = math.clamp((camera.fovy + (rl.getMouseWheelMove() * -1.5)), fovMin, fovMax);
    // }
}

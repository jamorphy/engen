const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "zengine",
        .root_source_file = b.path("src/main.zig"),
        .target = b.host,
    });

    @import("system_sdk").addLibraryPathsTo(exe);

    { // Needed for glfw/wgpu rendering backend

        const zgui = b.dependency("zgui", .{
            .shared = false,
            .with_implot = true,
            .backend = .glfw_wgpu,
        });
        exe.root_module.addImport("zgui", zgui.module("root"));
        exe.linkLibrary(zgui.artifact("imgui"));
        
        const zglfw = b.dependency("zglfw", .{});
        exe.root_module.addImport("zglfw", zglfw.module("root"));
        exe.linkLibrary(zglfw.artifact("glfw"));

        // const zpool = b.dependency("zpool", .{});
        // exe.root_module.addImport("zpool", zpool.module("root"));

        @import("zgpu").addLibraryPathsTo(exe);
        const zgpu = b.dependency("zgpu", .{});
        exe.root_module.addImport("zgpu", zgpu.module("root"));
        exe.linkLibrary(zgpu.artifact("zdawn"));

        const zmath = b.dependency("zmath", .{});
        exe.root_module.addImport("zmath", zmath.module("root"));
    }

    b.installArtifact(exe);
}

const std = @import("std");
const LazyPath = std.Build.LazyPath;

pub const SourceItem = struct { name: []u8, api_export: bool };

pub fn nvim_gen_runtime(
    b: *std.Build,
    nlua0: *std.Build.Step.Compile,
    funcs_data: LazyPath,
) !*std.Build.Step.WriteFile {
    const gen_runtime = b.addWriteFiles();

    {
        const gen_step = b.addRunArtifact(nlua0);
        gen_step.addFileArg(b.path("src/gen/gen_vimvim.lua"));
        const file = gen_step.addOutputFileArg("generated.vim");
        _ = gen_runtime.addCopyFile(file, "syntax/vim/generated.vim");
        gen_step.addFileArg(funcs_data);
        gen_step.addFileArg(b.path("src/nvim/options.lua"));
        gen_step.addFileArg(b.path("src/nvim/auevents.lua"));
        gen_step.addFileArg(b.path("src/nvim/ex_cmds.lua"));
        gen_step.addFileArg(b.path("src/nvim/vvars.lua"));
    }

    //Generate help tags
    {
        const gen_step = b.addRunArtifact(nlua0);
        gen_step.addFileArg(b.path("src/gen/gen_helptags.lua"));
        const file = gen_step.addOutputFileArg("tags");
        _ = gen_runtime.addCopyFile(file, "doc/tags");
        gen_step.addDirectoryArg(b.path("runtime/doc"));
        gen_step.has_side_effects = true; // workaround: missing detection of input changes
    }

    {
        const gen_step = b.addRunArtifact(nlua0);
        gen_step.addFileArg(b.path("src/gen/gen_helptags.lua"));
        const file = gen_step.addOutputFileArg("tags");
        _ = gen_runtime.addCopyFile(file, "pack/dist/opt/netrw/doc/tags");
        gen_step.addDirectoryArg(b.path("runtime/pack/dist/opt/netrw/doc"));
        gen_step.has_side_effects = true; // workaround: missing detection of input changes
    }

    {
        const gen_step = b.addRunArtifact(nlua0);
        gen_step.addFileArg(b.path("src/gen/gen_helptags.lua"));
        const file = gen_step.addOutputFileArg("tags");
        _ = gen_runtime.addCopyFile(file, "pack/dist/opt/matchit/doc/tags");
        gen_step.addDirectoryArg(b.path("runtime/pack/dist/opt/matchit/doc"));
        gen_step.has_side_effects = true; // workaround: missing detection of input changes
    }

    {
        //Install directories
        const install_autoload_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/autoload"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/autoload" });
        gen_runtime.step.dependOn(&install_autoload_files.step);

        const install_colors_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/colors"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/colors" });
        gen_runtime.step.dependOn(&install_colors_files.step);

        const install_compiler_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/compiler"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/compiler" });
        gen_runtime.step.dependOn(&install_compiler_files.step);

        const install_doc_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/doc"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/doc" });
        gen_runtime.step.dependOn(&install_doc_files.step);

        const install_ftplugin_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/ftplugin"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/ftplugin" });
        gen_runtime.step.dependOn(&install_ftplugin_files.step);

        const install_indent_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/indent"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/indent" });
        gen_runtime.step.dependOn(&install_indent_files.step);

        const install_keymap_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/keymap"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/keymap" });
        gen_runtime.step.dependOn(&install_keymap_files.step);

        const install_lua_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/lua"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/lua" });
        gen_runtime.step.dependOn(&install_lua_files.step);

        const install_pack_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/pack"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/pack" });
        gen_runtime.step.dependOn(&install_pack_files.step);

        const install_plugin_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/plugin"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/plugin" });
        gen_runtime.step.dependOn(&install_plugin_files.step);

        const install_queries_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/queries"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/queries" });
        gen_runtime.step.dependOn(&install_queries_files.step);

        const install_scripts_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/scripts"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/scripts" });
        gen_runtime.step.dependOn(&install_scripts_files.step);

        const install_spell_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/spell"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/spell" });
        gen_runtime.step.dependOn(&install_spell_files.step);

        const install_syntax_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/syntax"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/syntax" });
        gen_runtime.step.dependOn(&install_syntax_files.step);

        const install_tutor_files = b.addInstallDirectory(.{ .source_dir = b.path("runtime/tutor"), .install_dir = .prefix, .install_subdir = "share/nvim/runtime/tutor" });
        gen_runtime.step.dependOn(&install_tutor_files.step);

        //Install Files
        const install_delmenu_file = b.addInstallFile(b.path("runtime/delmenu.vim"), "share/nvim/runtime/delmenu.vim");
        gen_runtime.step.dependOn(&install_delmenu_file.step);

        const install_example_init_file = b.addInstallFile(b.path("runtime/example_init.lua"), "share/nvim/runtime/example_init.lua");
        gen_runtime.step.dependOn(&install_example_init_file.step);

        const install_filetype_file = b.addInstallFile(b.path("runtime/filetype.lua"), "share/nvim/runtime/filetype.lua");
        gen_runtime.step.dependOn(&install_filetype_file.step);

        const install_ftoff_file = b.addInstallFile(b.path("runtime/ftoff.vim"), "share/nvim/runtime/ftoff.vim");
        gen_runtime.step.dependOn(&install_ftoff_file.step);

        const install_ftplugin_file = b.addInstallFile(b.path("runtime/ftplugin.vim"), "share/nvim/runtime/ftplugin.vim");
        gen_runtime.step.dependOn(&install_ftplugin_file.step);

        const install_ftplugof_file = b.addInstallFile(b.path("runtime/ftplugof.vim"), "share/nvim/runtime/ftplugof.vim");
        gen_runtime.step.dependOn(&install_ftplugof_file.step);

        const install_indent_file = b.addInstallFile(b.path("runtime/indent.vim"), "share/nvim/runtime/indent.vim");
        gen_runtime.step.dependOn(&install_indent_file.step);

        const install_indoff_file = b.addInstallFile(b.path("runtime/indoff.vim"), "share/nvim/runtime/indoff.vim");
        gen_runtime.step.dependOn(&install_indoff_file.step);

        const install_makemenu_file = b.addInstallFile(b.path("runtime/makemenu.vim"), "share/nvim/runtime/makemenu.vim");
        gen_runtime.step.dependOn(&install_makemenu_file.step);

        const install_menu_file = b.addInstallFile(b.path("runtime/menu.vim"), "share/nvim/runtime/menu.vim");
        gen_runtime.step.dependOn(&install_menu_file.step);

        const install_neovim_file = b.addInstallFile(b.path("runtime/neovim.ico"), "share/nvim/runtime/neovim.ico");
        gen_runtime.step.dependOn(&install_neovim_file.step);

        const install_synmenu_file = b.addInstallFile(b.path("runtime/synmenu.vim"), "share/nvim/runtime/synmenu.vim");
        gen_runtime.step.dependOn(&install_synmenu_file.step);

        //Files not installed to runtime folder
        const install_desktop_file = b.addInstallFile(b.path("runtime/nvim.desktop"), "share/applications/nvim.desktop");
        gen_runtime.step.dependOn(&install_desktop_file.step);

        const install_icon_file = b.addInstallFile(b.path("runtime/nvim.png"), "share/icons/hicolor/128x128/apps/nvim.png");
        gen_runtime.step.dependOn(&install_icon_file.step);

        const install_man_file = b.addInstallFile(b.path("src/man/nvim.1"), "share/man/man1/nvim.1");
        gen_runtime.step.dependOn(&install_man_file.step);
    }

    return gen_runtime;
}

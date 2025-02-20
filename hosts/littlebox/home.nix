{ config, pkgs, inputs,... }:
let 
    system = "x86_64-linux";
in
{
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "box";
    home.homeDirectory = "/home/box";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "24.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = [
        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
        inputs.zen-browser.packages."${system}".specific
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/box/etc/profile.d/hm-session-vars.sh
    #
    home.sessionVariables = {
        EDITOR = "nvim";
    };

    programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
    };

    programs.fastfetch = {
        enable = true;
        settings = 
            {
                schema = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
                logo = {
                    padding = {
                        top = 2;
                        left = 1;
                        right = 2;
                    };
                };
                display = {
                    separator = " ";
                };
                modules = [
                    {
                        type = "title";
                        format = "{#1}╭───────────── {#}{user-name-colored}";
                    }
                    {
                        type = "custom";
                        format = "{#1}| {#}System Information";
                    }
                    {
                        type = "os";
                        key = "{#separator}| 󰍹 os";
                    }
                    {
                        type = "kernel";
                        key = "{#separator}│  {#keys}󰒋 Kernel";
                    }
                    {
                        type = "uptime";
                        key = "{#separator}│  {#keys}󰅐 Uptime";
                    }
                    {
                        type = "packages";
                        key = "{#separator}│  {#keys}󰏖 Packages";
                        format = "{all}";
                    }
                    {
                        type = "custom";
                        format = "{#1}│";
                    }
                    {
                        type = "custom";
                        format = "{#1}│ {#}Desktop Environment";
                    }
                    {
                        type = "de";
                        key = "{#separator}│  {#keys}󰧨 DE";
                    }
                    {
                        type = "display";
                        key = "{#separator}│  {#keys}󰹑 Resolution";
                    }
                    {
                        type = "shell";
                        key = "{#separator}│  {#keys}󰞷 Shell";
                    }
                    {
                        type = "custom";
                        format = "{#1}│";
                    }
                    {
                        type = "custom";
                        format = "{#1}│ {#}Hardware Information";
                    }
                    {
                        type = "cpu";
                        key = "{#separator}│  {#keys}󰻠 CPU";
                    }
                    {
                        key = "{#separator}│  {#keys}󰍛 Memory";
                        type = "memory";
                    }
                    {
                        type = "disk";
                        key = "{#separator}│  {#keys}󰋊 Disk (/)";
                        folders = "/";
                    }
                    {
                        type = "custom";
                            format = "{#1}│";
                    }
                    {
                        type = "colors";
                        key = "{#separator}│";
                        symbol = "circle";
                    }
                    {
                        type = "custom";
                            format = "{#1}╰───────────────────────────────╯";
                    }
                ];
            };
    };

    programs.starship.enable = true;

    # programs.ghostty = {
    #     enable = true;
    #     enableFishIntegration = true;
    #     installVimSyntax = true;
    #     settings = {
    #         theme = "Seti";
    #     };
    # };

    programs.kitty = {
        enable = true;
        shellIntegration.enableFishIntegration = true;
        font.name = "JetBrainsMono NFM";
        themeFile = "Seti";
    };

    programs.fish = {
        enable = true;
        interactiveShellInit = ''
         set fish_greeting
         alias lh "l -h"
         alias llh "ll -h"
        '';
        plugins = [
            {name = "puffer-fish"; src = pkgs.fishPlugins.puffer.src;}
            {name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src;}
            {name = "autopair"; src =  pkgs.fishPlugins.autopair.src;}
        ];
    };

    programs.git = {
        enable = true;
        userName = "seism";
        userEmail = "dcalejandro667@proton.me";
    };

    programs.zathura = {
        enable = true;
    };

    programs.tmux = {
        enable = true;
        shortcut = "Space";
        mouse = true;
        clock24 = true;
        keyMode = "vi";
        plugins = [ 
            pkgs.tmuxPlugins.vim-tmux-navigator 
            pkgs.tmuxPlugins.sensible
            { plugin = inputs.minimal-tmux.packages.${pkgs.system}.default; }
        ];
        extraConfig =  ''
bind C-l send-keys 'C-l'
        '';
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}

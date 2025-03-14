# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
    imports = [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default
    ];
    
    fonts.packages = with pkgs; [nerdfonts];

    # services.postgresql = {
    #     enable = true;
    #     ensureDatabases = [ "usach_segura" ];
    #     enableTCPIP = true;
    # };

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Set your time zone.
    time.timeZone = "America/Santiago";

    # Select internationalisation properties.
    i18n.defaultLocale = "es_AR.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "es_CL.UTF-8";
        LC_IDENTIFICATION = "es_CL.UTF-8";
        LC_MEASUREMENT = "es_CL.UTF-8";
        LC_MONETARY = "es_CL.UTF-8";
        LC_NAME = "es_CL.UTF-8";
        LC_NUMERIC = "es_CL.UTF-8";
        LC_PAPER = "es_CL.UTF-8";
        LC_TELEPHONE = "es_CL.UTF-8";
        LC_TIME = "es_CL.UTF-8";
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    # services.xserver.displayManager.gdm.enable = true;
    # services.xserver.desktopManager.gnome.enable = true;

    #Enable Plasma 6 DE
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        elisa
        konsole
        kate
    ];

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "latam";
        variant = "";
    };

    virtualisation.docker.enable = true;

    # Configure console keymap
    console.keyMap = "la-latin1";

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    documentation.dev.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.box = {
        isNormalUser = true;
        description = "box";
        extraGroups = [ "networkmanager" "wheel" "docker"];
        packages = with pkgs;
            [
                #  thunderbird
                tela-circle-icon-theme
                unrar-wrapper
            ];
    };

    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users = { "box" = import ./home.nix; };
    };

    #Shell stuff
    programs.fish.enable = true;

    programs.bash = {
        interactiveShellInit = ''
     if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
     then
       shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
       exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
     fi
        '';
    };


    # Enable automatic login for the user.
    # services.xserver.displayManager.autoLogin.user = "box";
    # services.xserver.displayManager.autoLogin.enable = true;

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    # systemd.services."autovt@tty1".enable = false;
    # systemd.services."getty@tty1".enable = false;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        #  wget
        git
        gcc
        gnumake
        wl-clipboard
        man-pages
        man-pages-posix
        # pkgs.file-roller
        # pkgs.gnomeExtensions.appindicator
        # pkgs.gnomeExtensions.blur-my-shell
        # pkgs.gnomeExtensions.caffeine
        # pkgs.gnomeExtensions.compiz-alike-magic-lamp-effect
        # pkgs.gnomeExtensions.dash-to-dock
        # pkgs.gnomeExtensions.just-perfection
        # pkgs.gnomeExtensions.logo-menu
        # pkgs.gnomeExtensions.media-controls
        # pkgs.gnome-tweaks
        bitwarden
    ];

    # environment.gnome.excludePackages = with pkgs; [ 
    #     geary
    #     gnome-tour
    #     epiphany
    #     evince
    # ];

    programs.nixvim = {
        enable = true;
        imports = [ inputs.Neve.nixvimModule ];
        viAlias = true;
        vimAlias = true;
        
        opts = {
            shiftwidth = lib.mkForce 4;
            tabstop = lib.mkForce 4;
        };

        performance = {
            byteCompileLua.enable = true;
        };
    
        clipboard = {
            providers.wl-copy.enable = true;
        };

        plugins = {
	    lsp.servers.ts_query_ls.enable = lib.mkForce false;
            wakatime.enable = lib.mkForce false;
            lint.enable = lib.mkForce false;
            zen-mode.enable = true;
            render-markdown.enable = true;
            smartcolumn.enable = true;
            vimtex.enable = lib.mkForce false;
            fidget.enable = lib.mkForce false; # Workaround because of renamed opts
            copilot-lua.enable = lib.mkForce false;

            lualine = {
                settings.options.section_separators = {
                    left = "|";
                    right = "|";
                };
            };
            smartcolumn.settings = {
                disabled_filetypes = [
                    "markdown"
                    "checkhealth"
                    "help"
                    "lspinfo"
                    "text"
                    "latex"
                ];
            };
        };
        extraPackages = with pkgs; [
            pyright
            ruff
        ];
    };


    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    services.flatpak.enable = true;

    systemd.services.flatpak-repo = {
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.flatpak ];
            script = '' 
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      ''; 
    };

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    #networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?

}

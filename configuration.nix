# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  boot.resumeDevice = "/dev/mapper/cryptroot";
  swapDevices = [{device = "/swapfile"; size = 20000;}];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./computerSpecific.nix
    ];

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.kernelParams = [ "resume=/swapfile" "resume_offset=16711680" ];
  boot.loader.efi.canTouchEfiVariables = true;

  # Pick only one of the below networking options.
  networking = {
    hostName = "pahvi";
    # wireless.iwd.enable = true;  # Enables wireless support via wpa_supplicant.
    nameservers = [ "1.1.1.1" "8.8.8.8" "1.0.0.1" ];
    networkmanager = {
      dispatcherScripts = [{ 
        source = pkgs.writeText "copyIPToLunttiNet" ''
          #!/usr/bin/env ${pkgs.bash}/bin/bash
          while ! ${pkgs.iputils}/bin/ping luntti.net -c1;do sleep 1;done 2>>/home/ileska/test2
          IP=$(ip route | head -1 | cut -d\  -f9) 
          if [[ "$IP" != "$(cat /home/ileska/script/IP)" ]] && [[ "$IP" != "" ]];
          then
            echo -e "$IP" > /home/ileska/scripts/IP 
            ${pkgs.su}/bin/su ileska -c "${pkgs.openssh}/bin/scp -i /home/ileska/.ssh/id_ed25520 /home/ileska/scripts/IP ileska@luntti.net:ileska.luntti.net/koneIP/index.html"
          fi
        ''; 
        type = "basic";
        }];
      enable = true;  # Easiest to use and most distros use this by default.
      appendNameservers = [ "1.1.1.1" "8.8.8.8" "1.0.0.1" ];
    wifi.macAddress = "stable";
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  programs.light.enable = true;

  security.rtkit.enable = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true;
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  programs.wireshark.enable = true;
  users.users.ileska = {
    isNormalUser = true;
    description = "Ileska";
    extraGroups = [ "docker" "music" "wireshark" "libvirtd" "networkmanager" "wheel" "adbusers" "video" "dialout" ];
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.opengl.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    thunderbird
    mailutils
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    libreoffice
    xorg.xmodmap
    wget jq yt-dlp
    tmux
    kitty
    i3
    home-manager
    librewolf
    usbutils
    feh
    htop
    wireshark
    alsa-utils
    mpv
    git
    libqalculate
    keepassxc
    google-chrome
    xclip 
    flameshot 
    # maim
    tesseract5
    inkscape gimp
    dunst libnotify
    usbguard
    virt-manager
    xdotool
    playerctl
    neofetch 
    gcc gdb gnumake
    tor-browser-bundle-bin
    prismlauncher
    socat nmap
    tree file
    arandr
    (st.overrideAttrs (oldAttrs: rec {
      buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
      patches = [
        (fetchpatch {
          url = "https://st.suckless.org/patches/scrollback/st-scrollback-0.8.5.diff";
          sha256 = "ZZAbrWyIaYRtw+nqvXKw8eXRWf0beGNJgoupRKsr2lc=";
        })
      ];
    }))
  ];


  programs.adb.enable = true;

  environment.variables.EDITOR = "nvim"; 
  programs.neovim.enable = true;
  programs.neovim.viAlias = true;

  programs.kdeconnect.enable = true;



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services = {
    openssh.enable = true;
    openssh.settings.X11Forwarding = true;
    logind = {
      lidSwitch = "ignore";
      extraConfig = ''
        HandlePowerKey=ignore
      '';
    };

    xserver = {
      enable = true; 
      layout = "us";
      xkbVariant = "colemak";

      videoDrivers = [ "modesettings" ];
      deviceSection = ''
        Option "DRI" "2"
        Option "TearFree" "true"
      '';


      libinput.enable = true;
      autoRepeatDelay = 250;
      autoRepeatInterval = 40;
      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap -e 'keycode 94 = Escape'";
        defaultSession = "none+i3";
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu 
          i3status-rust
          i3lock-color
        ];
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    blueman.enable = true;

    usbguard = {
      enable = false;
      rules = ''
        allow id 0951:1666 serial "60A44C426695B2307625AF6E" name "DataTraveler 3.0" hash "G9dYep3+lK68Q3EkjwxaBOXk+YUi7z822jtOfviEgoQ=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-3" with-interface 08:06:50 with-connect-type "hotplug"
	allow id 2341:0043 serial "5573132383635121A171" name "" hash "uLEqY4iSESGM/vpI/bijPP41IQAr5wqnrOoAV0IWL68=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-3" with-interface { 02:02:01 0a:00:00 } with-connect-type "hotplug"

      '';
    };
    gvfs.enable = true;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 25 53 80 22 143 400 443 587 465 5432 8000 8080 ];
  networking.firewall.allowedUDPPorts = [ 25 53 80 22 143 400 443 587 465 5432 8000 8080 51820 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  programs.dconf.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}

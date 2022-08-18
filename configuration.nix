# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  boot.resumeDevice = "/dev/mapper/cryptroot";
  swapDevices = [{device = "/swapfile"; size = 10000;}];


  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Pick only one of the below networking options.
  networking = {
    hostName = "pahvi";
    # wireless.iwd.enable = true;  # Enables wireless support via wpa_supplicant.
    nameservers = [ "8.8.8.8" "1.0.0.1" "1.1.1.1" ];
    networkmanager = {
      dispatcherScripts = [{ 
        source = pkgs.writeText "copyIPToLunttiNet" ''
          #!/usr/bin/env ${pkgs.bash}/bin/bash
          echo "moi0" >>/home/ileska/test 
          echo "moi1 $(date)" >>/home/ileska/test 
          while ! ${pkgs.iputils}/bin/ping luntti.net -c1;do sleep 1;done 2>>/home/ileska/test2
          echo "moi2 $(date)" >>/home/ileska/test 
          IP=$(ip route | head -1 | cut -d\  -f9) 
          echo "moi3 $(date)" >>/home/ileska/test 
          if [[ "$IP" != "$(cat /home/ileska/script/IP)" ]] && [[ "$IP" != "" ]];
          then
            echo -e "$IP" > /home/ileska/scripts/IP 
            ${pkgs.su}/bin/su ileska -c "${pkgs.openssh}/bin/scp -i /home/ileska/.ssh/id_ed25520 /home/ileska/scripts/IP ileska@luntti.net:ileska.luntti.net/koneIP/index.html"
          fi
        ''; 
        type = "basic";
        }];
      enable = true;  # Easiest to use and most distros use this by default.
      appendNameservers = [ "8.8.8.8" "1.0.0.1" "1.1.1.1" ];
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

  users.users.ileska = {
    isNormalUser = true;
    description = "Ileska";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "video" ];
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
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
    chromium
    xclip maim
    inkscape
    dunst libnotify
    (st.overrideAttrs (oldAttrs: rec {
      buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
      patches = [
        (fetchpatch {
          url = "https://st.suckless.org/patches/scrollback/st-scrollback-0.8.5.diff";
          sha256 = "0mgsklws6jsrngcsy64zmr604qsdlpd5pqsa3pci7j3gn8im4zyw";
        })
      ];
    }))
  ];

  programs.adb.enable = true;

  environment.variables.EDITOR = "nvim"; 
  programs.neovim.enable = true;
  programs.neovim.viAlias = true;



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
    picom.enable = true;
    logind.lidSwitch = "ignore";

    xserver = {
      enable = true; 
      layout = "us";
      xkbVariant = "colemak";
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
          i3status
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
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

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
  system.stateVersion = "22.05"; # Did you read the comment?
}

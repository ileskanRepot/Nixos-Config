{ config, pkgs, ... }:
{
  imports = [
    (builtins.fetchTarball {
      # Pick a release version you are interested in and set its hash, e.g.
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-23.05/nixos-mailserver-nixos-23.05.tar.gz";
      # To get the sha256 of the nixos-mailserver tarball, we can use the nix-prefetch-url command:
      # release="nixos-23.05"; nix-prefetch-url "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz" --unpack
      sha256 = "1ngil2shzkf61qxiqw11awyl81cr7ks2kv3r3k243zz7v2xakm5c";
    })
  ];

  # NVIDIA drivers are unfree.
  # nixpkgs.config.allowUnfree = true;


  # services.xserver.videoDrivers = [ "nvidia" "intel" ];
  # hardware.opengl.enable = true;

  # hardware.nvidia.package = linuxPackages_6_0.nvidiaPackages.production;
  # hardware.nvidia.nvidiaPersistenced = true;
  # hardware.bumblebee.enable = true;
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "ileska" "keycloak" ];
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      host  all      all     127.0.0.1/32   trust
      host  all      all     ::1/128        trust
      host  all      all     0.0.0.0/0       md5
    '';
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;

    virtualHosts."ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:5173/";
      locations."/api".proxyPass = "http://0.0.0.0:5170/api";
      default = true;
    };
    virtualHosts."music.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:5173/";
      locations."/api".proxyPass = "http://0.0.0.0:5170/api";
    };
    virtualHosts."loz0.kyla.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:5173/";
      locations."/api".proxyPass = "http://0.0.0.0:8000/api";
    };
    virtualHosts."matrix.ileska.fi" = {
      locations."/".proxyPass = "http://0.0.0.0:8008/";
      locations."/_synapse/admin".index = "404";
    };
    virtualHosts."foodsafe.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:8765/";
    };
    virtualHosts."download.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:8080/";
    };
    virtualHosts."wsd.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:7777/";
    };
    virtualHosts."shoppinglist.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:5000/";
    };
    virtualHosts."quiz.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:5001/";
    };
    virtualHosts."cv.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/cv.ileska.fi";
      # locations."/".tryFiles = "/home/ileska/.bashrc";
    };
    virtualHosts."isup.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:4000/";
      # locations."/".tryFiles = "/home/ileska/.bashrc";
    };
    virtualHosts."auth.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:6001/";
      # locations."/".proxyPass = "http://0.0.0.0:6002/";
      # locations."/".tryFiles = "/home/ileska/.bashrc";
      extraConfig =
       # required when the target is also TLS server with multiple hosts
       # required when the server wants to use HTTP Authentication
       "proxy_set_header Host               $host;" +

       "proxy_set_header X-Forwarded-For    $remote_addr;" +

       "proxy_set_header X-Forwarded-Host   $host;" +
       "proxy_set_header X-Forwarded-Port   443;" +
       "proxy_set_header X-Forwarded-Proto  $scheme;" +
       "proxy_set_header X-Forwarded-Scheme $scheme;" +

       "proxy_set_header X-Scheme           $scheme;" +
       "proxy_set_header X-Original-Forwarded-For  $http_x_forwarded_for;" +

       "proxy_set_header Proxy              \"\";" +

       "proxy_next_upstream                 error timeout;" +
       "proxy_next_upstream_timeout         0;" +
       "proxy_next_upstream_tries           3;" +
       "proxy_redirect                      off;"
       ;

    };
    virtualHosts."niilo.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/niilo.ileska.fi";
      # locations."/".tryFiles = "/home/ileska/.bashrc";
    };
  };

/*
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "matrix.ileska.fi";
      registration_shared_secret ="xFfvbXgpwJ0fkFPOq8y05FDRly1RfYkkJnrYx1SyuIWoyxTXuIiqO7SQq2ivWMYX";
      database_type = "psycopg2";
      database_args = {
        database = "matrix-synapse";
      };
      extraConfig = ''
        max_upload_size: "50M"
      '';
    # registration_shared_secret = "kt0dce3HSg7bL8VAO1fWdOwL5A7jLmKY5nzPJ5KcFD6hKx4mEGC2pyKq7UdJHkiW";
    };
  };
*/

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "eth0";
    internalInterfaces = [ "wg0" ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "ileska@tutanota.com";

    /*
    certs."auth.ileska.fi" = {
      email = "ileska@tutanota.com";
      listenHTTP = "auth.ileska.fi:80";
    };
    */
  };

  mailserver = {
    enable = true;
    fqdn = "mail.ileska.fi";
    domains = [ "ileska.fi" ];
    certificateScheme = "acme-nginx";

    loginAccounts = {
      "ileska@ileska.fi" = {
        hashedPassword = "$6$WI2KjBW183WtKuQH$FnHV6SGwmqyw5ldkXDf7SaG3BZfM76iAC43FMOuljejQZz9uM9Rsodwfzfox6MwFy669fagfPDAF98vc30Lza0";
        aliases = ["me@ileska.fi" "akseli@ileska.fi"];
      };
    };
    virusScanning = false;
  };
  
  services.keycloak = {
    enable = true;
    settings = {
      hostname = "auth.ileska.fi";
      hostname-strict-backchannel = true;
      hostname-strict = false;
      hostname-strict-https = false;
      proxy = "edge";
      proxy-address-forwarding = "true";
      http-host = "localhost";
      http-port = 6001;

       # = "auth.ileska.fi";
      http-enabled = true;

      ssl-required = false;
    };
    database = {
      createLocally = false;
      host = "localhost";
      port = 5432;
      type = "postgresql";
      name = "keycloak";
      username = "keycloak";
      useSSL = false;
      passwordFile = "/var/certs/psw/postgesPsw";
    };
    # initialAdminPassword = "";  # change on first login
    # sslCertificate = "/var/certs/psw/auth.crt";
    # sslCertificateKey = "/var/certs/psw/auth.key";
   };
}

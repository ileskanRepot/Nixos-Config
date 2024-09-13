{ config, pkgs, ... }:
{
  imports = [
    (builtins.fetchTarball {
      # Pick a release version you are interested in and set its hash, e.g.
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/master/nixos-mailserver-master.tar.gz";
      # To get the sha256 of the nixos-mailserver tarball, we can use the nix-prefetch-url command:
      # release="nixos-23.05"; nix-prefetch-url "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz" --unpack
      sha256 = "1j0r52ij5pw8b8wc5xz1bmm5idwkmsnwpla6smz8gypcjls860ma";
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
    ensureDatabases = [ "ileska" "keycloak" "jobsDb" ];
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
      root = "/var/www/ileska.fi";
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
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:8008/";
      locations."/_synapse/admin".index = "404";
    };
    virtualHosts."foodsafe.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:8765/";
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
    virtualHosts."links.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:4010/";
      # locations."/".tryFiles = "/home/ileska/.bashrc";
    };
    virtualHosts."jobs.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:4001/";
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
    virtualHosts."docs.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/docs.ileska.fi";
      # locations."/".tryFiles = "/home/ileska/.bashrc";
    };
    virtualHosts."ssh.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:5173/";
      locations."/api".proxyPass = "http://0.0.0.0:8000/api";
    };

    virtualHosts."pass.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://0.0.0.0:9001/";
    };

    virtualHosts."files.ileska.fi" = {
      addSSL = true;
      enableACME = true;
      root = "/var/www/files.ileska.fi";
      locations."/".extraConfig = "autoindex on;";
    };
    /* virtualHosts."asWebTest.ileska.fi" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://192.168.0.43:8000/";
    }; */
  };

  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "matrix.ileska.fi";
      registration_shared_secret ="My Secret PRKL";
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
      # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
      "ileska@ileska.fi" = {
        hashedPassword = "My Secrter PRKL";
        aliases = ["me@ileska.fi" "akseli@ileska.fi"];
        catchAll = ["ileska.fi"];
      };
      "jobs@ileska.fi" = {
        hashedPassword = "My Secrter PRKL";
      };
    };
    virusScanning = false;
  };
  
 
  /*
  services.keycloak = {
    enable = true;
    settings = {
      hostname = "auth.ileska.fi";
      # hostname-strict-backchannel = true;
      hostname-backchannel-dynamic = true;
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
   */

}

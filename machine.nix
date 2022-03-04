{ lib, pkgs, ... }:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/dummy";
  fileSystems."/" =
    { device = "/dev/dummy";
      fsType = "ext4";
    };

  networking = {
    firewall.enable = false;
    useDHCP = false;
    useNetworkd = true;
    nftables = {
      enable = true;
      ruleset =
        ''
        '';
    };

  };

  security.acme = {
    email = "dummy@dummy.dummy";
    acceptTerms = true;
    certs = {
      "dummy.dummy.dummy" = {
        webroot = "/var/www/dummy.dummy";
        email = "dummy@dummy.dummy";
        group = "dummy";
      };
    };
  };

  services.resolved = { enable = false; };

  services = {
    openssh = {
      enable = true;
    };
    prometheus.exporters.node = {
      enable = true;
    };

    # Pleroma-related stuff
    pleroma = {
      enable = true;
      configs = [
        ''
          wont start heh
        ''
      ];
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_12;

      initialScript = pkgs.writeText "synapse-init.sql" ''
      '';
      settings = {
      };
    };

    matrix-synapse = {
      enable = true;
      server_name = "dummy.dummy";
      public_baseurl = "https://dummy.dummy";
      database_type = "psycopg2";
      registration_shared_secret = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
      database_args = {
        user = "dummy";
        database = "dummy";
        cp_min = 5;
        cp_max = 10;
      };
      report_stats = true;
      enable_metrics = true;
      listeners = [
      ];

      servers = {
        "matrix.org" = {
          "ed25519:auto" = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
        };
      };

    };

    nginx = {
      enable = true;
      virtualHosts."dummy.dummy" = {
        enableACME = true;
        forceSSL = true;
        root = "/var/www/dummy.dummy";
      };
    };
  };

  programs = {
    mosh.enable = true;
  };

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    wget
    vim
    sshfs
    git
    htop
    tcpdump
    nmap
    tmux
    rsync
    mtr
    wireguard-tools
  ];

  system.stateVersion = "20.03";
}

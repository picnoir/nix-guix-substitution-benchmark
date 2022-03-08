{ system ? builtins.currentSystem }:
let
  buildNixOSConfig = nixpkgs: topLevelModule:
    (import "${nixpkgs}/nixos/lib/eval-config.nix" {
        inherit system;
        modules = [ topLevelModule ];
  }).config.system.build.toplevel;

  pkgBump = nixpkgsPins: attr: {
    before = (import nixpkgsPins.before {})."${attr}";
    after = (import nixpkgsPins.after {})."${attr}";
  };
  # Staging-next merge leading (among other things) to a curl bump
  # See https://github.com/NixOS/nixpkgs/pull/148396 for full log
  nixpkgsMassRebuild = {
    after = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/dfc501756b09fa40f9eeb4a1c12ccd225ba3e3d8.tar.gz";
        sha256 = "sha256:0l02pvjyq7zvhl1vfkwvkcnhmcw6kajszvh660shhm9ccj4cq5ld";
    };
    before = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/43cc623340ac0723fb73c1bce244bb6d791c5bb9.tar.gz";
        sha256 = "sha256:12vlzhaawmvr6did2j4dbqnb6v71b1xi8pi72072w8vw5mfjr9n7";
    };
  };

  nixpkgsChannels = {
    unstable = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/c07b471b52be8fbc49a7dc194e9b37a6e19ee04d.tar.gz";
        sha256 = "sha256:1qg18fp136rvazmiaq63ka36jb6md9d5s9y5gfi4h71l7kmdkvc8";
    };
    stable = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/b3d86c56c786ad9530f1400adbd4dfac3c42877b.tar.gz";
        sha256 = "sha256:09nslcjdgwwb6j9alxrsnq1wvhifq1nmzl2w02l305j0wsmgdial";
    };
  };

  firefoxBump = {
    after = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/7e23a7fb8268f16e83ef60bbd2708e1d57fd49ef.tar.gz";
        sha256 = "sha256:1y4iw5cv9h7kg3ay8wn618gaqhw2xgmmib93lc24hg02hk9cc965";
    };
    before = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/ac247ed8315bead7d1c5d32a8058790149e6ad50.tar.gz";
        sha256 = "sha256:03xg1mwj0fcy1ry8hl8mpjnwnv91ly8sy3xm3kjsw78l0qmxj7hq";
    };
  };

  gimpBump = {
    after = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/998234e12e971670ebdc071ca5c8c0aae08a76aa.tar.gz";
        sha256 = "sha256:1ddpknj37xk8rvhxcd0c6jrns037y652pmawkx8nb5yfyzknpiy4";
    };
    before = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/7ec5348c9c830a6e9fac8b791cd790d711ca218c.tar.gz";
        sha256 = "sha256:11mbrw2wzgmrfjwrgp94dsmvmg74gbw152ll3kkkl94h37h3069i";
    };
  };

  emacsBump = {
    after = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/7d10c949fa3cb4d9f44e6a8017b89f55bf58f07d.tar.gz";
        sha256 = "sha256:1xj1lzv6nf0ajzsshfkc21j83fh83yry6325imsgnki6kdp2arnh";
    };
    before = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/87f578a36fb3bcb2e9b9533dd360b5aa16ebfc90.tar.gz";
        sha256 = "sha256:1rns6658zb7k0gm0rhq00qqxbgmfprrchr1qarqsvhzip3ayziqx";
    };
  };

  openmpiBump = {
    after = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/04088dafe9099c65e08e6217e006a28d7f448fa0.tar.gz";
        sha256 = "sha256:1dgn2229a2hmmbpi69y6wzr9bljwnlfm6ch5z476kz0izjpzcjxk";
    };
    before = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/fc9ee3bc0b9e6d30f76f4b37084711ae03114e21.tar.gz";
        sha256 = "sha256:14l6rpxydam84c9igiwgn9846w61022ba8665dbqb6lkpi15hldj";
    };
  };

  pkgs = import nixpkgsChannels.unstable {};
in {
  nix-casync = pkgs.buildGoModule rec {
    pname = "nix-casync";
    version = "0.5";
    vendorSha256 = "sha256-yViWx57W9hLDyUpSu5SsiST1JFBC3OHqQ7viKYklgoc=";
    src = pkgs.fetchFromGitHub {
        owner = "flokli";
        repo = pname;
        rev = "v${version}";
        sha256 = "sha256-JYlUYp2V0sL1gzVBTx/Hh4aIM9Z8AnfV+aznlk6g2cw=";
    };
  };
  massRebuild = {
    before = buildNixOSConfig nixpkgsMassRebuild.before ./machine.nix;
    after = buildNixOSConfig nixpkgsMassRebuild.after ./machine.nix;
  };
  nixpkgsChannels = {
    stable = buildNixOSConfig nixpkgsChannels.stable ./machine.nix;
    unstable = buildNixOSConfig nixpkgsChannels.unstable ./machine.nix;
  };

  firefoxBump = pkgBump firefoxBump "firefox";
  gimpBump = pkgBump gimpBump "gimp";
  emacsBump = pkgBump emacsBump "emacs";
  openmpiBump = pkgBump openmpiBump "openmpi";
}

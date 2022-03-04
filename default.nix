{ system ? builtins.currentSystem }:
let
  buildNixOSConfig = nixpkgs: topLevelModule:
    (import "${nixpkgs}/nixos/lib/eval-config.nix" {
        inherit system;
        modules = [ topLevelModule ];
  }).config.system.build.toplevel;


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
  firefoxBump = {
    before = (import firefoxBump.before {}).firefox;
    after = (import firefoxBump.after {}).firefox;
  };
}

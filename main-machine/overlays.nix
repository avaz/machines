[
    (final: prev: {
      gh = prev.gh.overrideAttrs (old: {
        version = "2.82.0";
        src = prev.fetchFromGitHub {
          owner = "cli";
          repo = "cli";
          rev = "v2.82.0";
          sha256 = "11a5zmn27778haz52cwwd42dip9drwd8diymzrifr5a0sfamxy6h";
        };
        vendorHash = "sha256-rVNKTr3b4zShPfkiEBx7LqVQY2eMrXo/s8iC5tyQZNo=";
      });
    })
    (final: prev: {
      git-town = prev.buildGoModule rec {
        pname = "git-town";
        version = "22.5.0";
        src = prev.fetchFromGitHub {
          owner = "git-town";
          repo = "git-town";
          rev = "v${version}";
          hash = "sha256-7+KCk46TOnOVmmhYtqzC6kC3wQUdWkQKoSpoyb9D9tQ=";
        };
        vendorHash = null;
        doCheck = false;
        ldflags = [ "-s" "-w" "-X github.com/git-town/git-town/v${prev.lib.versions.major version}/src/cmd.version=v${version}" ];
        nativeBuildInputs = [ prev.installShellFiles ];
        postInstall = ''
          installShellCompletion --cmd git-town \
            --bash <($out/bin/git-town completions bash) \
            --fish <($out/bin/git-town completions fish) \
            --zsh <($out/bin/git-town completions zsh)
        '';
      };
    })
  ]